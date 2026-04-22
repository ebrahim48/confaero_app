import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/video_conference_controller.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoConferenceController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // App bar
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,
                          size: 24.sp, color: AppColors.textColor424242),
                    ),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: 'Live Sessions',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff32A69A),
                  ),
                );
              }

              if (controller.sessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off,
                          size: 64.r, color: Colors.grey.shade300),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: 'No live sessions available',
                        fontsize: 15.sp,
                        color: AppColors.textColor7E7F7E,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xff32A69A),
                onRefresh: controller.loadSessions,
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    return _SessionCard(
                      session: controller.sessions[index],
                      controller: controller,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VideoConferenceController controller;

  const _SessionCard({required this.session, required this.controller});

  @override
  Widget build(BuildContext context) {
    final sessionIndex = (session['sessionIndex'] as num?)?.toInt() ?? 0;
    final title = session['title']?.toString() ?? 'Session $sessionIndex';
    final date = session['date']?.toString() ?? '';
    final time = session['time']?.toString() ?? '';
    final liveStatus = session['liveStatus']?.toString() ?? '';
    final startedAt = session['startedAt']?.toString() ?? '';
    final isLive = liveStatus == 'LIVE';
    final isEnded = liveStatus == 'ENDED';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLive
              ? Colors.red.withOpacity(0.3)
              : const Color(0xffE0E0E0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    text: title,
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor424242,
                  ),
                ),
                SizedBox(width: 8.w),
                _StatusBadge(liveStatus: liveStatus),
              ],
            ),

            SizedBox(height: 10.h),

            // Date & Time row
            Row(
              children: [
                if (date.isNotEmpty) ...[
                  Icon(Icons.calendar_today_outlined,
                      size: 14.sp, color: AppColors.textColor7E7F7E),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: date,
                    fontsize: 12.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                  SizedBox(width: 12.w),
                ],
                if (time.isNotEmpty) ...[
                  Icon(Icons.access_time_outlined,
                      size: 14.sp, color: AppColors.textColor7E7F7E),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: time,
                    fontsize: 12.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                ],
              ],
            ),

            // startedAt (only when LIVE)
            if (isLive && startedAt.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.fiber_manual_record,
                      size: 10.sp, color: Colors.red),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: 'Started at ${_formatStartedAt(startedAt)}',
                    fontsize: 11.sp,
                    color: Colors.red,
                  ),
                ],
              ),
            ],

            if (!isEnded) ...[
              SizedBox(height: 14.h),
              Divider(color: const Color(0xffF0F0F0), height: 1),
              SizedBox(height: 12.h),
              Obx(() => _ActionButtons(
                    sessionIndex: sessionIndex,
                    isLive: isLive,
                    controller: controller,
                    context: context,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  String _formatStartedAt(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$min $period';
    } catch (_) {
      return raw;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String liveStatus;
  const _StatusBadge({required this.liveStatus});

  @override
  Widget build(BuildContext context) {
    final isLive = liveStatus == 'LIVE';
    final isEnded = liveStatus == 'ENDED';

    Color bg;
    Color fg;
    String label;

    if (isLive) {
      bg = Colors.red.withOpacity(0.1);
      fg = Colors.red;
      label = 'LIVE';
    } else if (isEnded) {
      bg = Colors.grey.shade100;
      fg = Colors.grey;
      label = 'ENDED';
    } else {
      bg = const Color(0xffE8F5F3);
      fg = const Color(0xff32A69A);
      label = liveStatus.isEmpty ? 'SCHEDULED' : liveStatus.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            Icon(Icons.fiber_manual_record, size: 8.sp, color: fg),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final int sessionIndex;
  final bool isLive;
  final VideoConferenceController controller;
  final BuildContext context;

  const _ActionButtons({
    required this.sessionIndex,
    required this.isLive,
    required this.controller,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final isThisLoading = controller.loadingIndex.value == sessionIndex;

    if (isThisLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Color(0xff32A69A)),
        ),
      );
    }

    final isSpeaker = controller.isSpeaker;

    if (isLive) {
      return Row(
        children: [
          _Btn(
            label: 'Join',
            color: const Color(0xff32A69A),
            icon: Icons.play_circle_outline,
            onTap: () => controller.joinSession(sessionIndex),
          ),
          if (isSpeaker) ...[
            SizedBox(width: 8.w),
            _Btn(
              label: 'End',
              color: Colors.red,
              icon: Icons.stop_circle_outlined,
              onTap: () => controller.endSession(context, sessionIndex),
            ),
          ],
        ],
      );
    }

    // Not live yet
    if (isSpeaker) {
      return _Btn(
        label: 'Start',
        color: const Color(0xff32A69A),
        icon: Icons.videocam_outlined,
        onTap: () => controller.startSession(sessionIndex),
      );
    }

    // Attendee + not LIVE → nothing to do
    return const SizedBox.shrink();
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _Btn({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16.sp, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 0,
      ),
    );
  }
}
