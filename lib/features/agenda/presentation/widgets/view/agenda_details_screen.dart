import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/agenda_details_controller.dart';
import '../action_button_widgets.dart';
import '../section_header_widgets.dart';
import '../spark_card_widgets.dart';

class AgendaDetailsScreen extends StatefulWidget {
  final String sessionIdx;

  const AgendaDetailsScreen({super.key, required this.sessionIdx});

  @override
  State<AgendaDetailsScreen> createState() => _AgendaDetailsScreenState();
}

class _AgendaDetailsScreenState extends State<AgendaDetailsScreen> {
  late final AgendaDetailsController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AgendaDetailsController>()) {
      Get.delete<AgendaDetailsController>(force: true);
    }
    controller = Get.put(AgendaDetailsController(widget.sessionIdx));
  }

  @override
  void dispose() {
    Get.delete<AgendaDetailsController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Obx(() => CustomAppBarWidget(title: controller.sessionTitle)),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 300.h,
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff5BB8AE)),
                    ),
                  );
                }

                final session = controller.sessionDetails;
                final sessionData =
                    (session['session'] as Map<String, dynamic>?) ?? {};
                final isOnline = sessionData['isOnline'] as bool? ?? false;
                final liveStatus =
                    sessionData['liveStatus']?.toString() ?? '';
                final liveProvider =
                    sessionData['liveProvider']?.toString() ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Session Info Card ─────────────────────────────
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border:
                            Border.all(color: const Color(0xffE0E0E0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x26000000),
                            blurRadius: 6,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: sessionData['title']?.toString() ??
                                'Untitled Session',
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff252525),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.time.svg(),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: CustomText(
                                  text: _formatDateTime(
                                    sessionData['date']?.toString(),
                                    sessionData['time']?.toString(),
                                  ),
                                  fontsize: 12.sp,
                                  color: const Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.location.svg(),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: sessionData['floorMapLocation'] != null
                                    ? 'Floor Map Available'
                                    : 'Location TBD',
                                fontsize: 12.sp,
                                color: const Color(0xff757575),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => controller.viewMap(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD2D2D2),
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(4.r),
                                  ),
                                  child: CustomText(
                                    text: 'View Map',
                                    fontsize: 10.sp,
                                    color: const Color(0xff252525),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Action Buttons ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          svgIcon: 'assets/icons/qa.svg',
                          text: 'Q&A',
                          onTap: () => controller.openQA(context),
                        ),
                        ActionButton(
                          svgIcon: 'assets/icons/poll.svg',
                          text: 'Poll',
                          onTap: () => controller.openPoll(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          svgIcon: 'assets/icons/note.svg',
                          text: 'Note',
                          onTap: () => controller.openNote(context),
                        ),
                        Obx(() => ActionButton(
                              svgIcon: 'assets/icons/like.svg',
                              text: 'Like',
                              onTap: () => controller.toggleLike(),
                              iconColor: controller.isLiked.value
                                  ? const Color(0xffE53935)
                                  : null,
                            )),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // ── Session Overview ──────────────────────────────
                    const SectionHeader(title: 'Session Overview'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: CustomText(
                        textAlign: TextAlign.start,
                        maxline: 10,
                        text: sessionData['details']
                                    ?.toString()
                                    .isNotEmpty ==
                                true
                            ? sessionData['details'].toString()
                            : 'No overview available',
                        fontsize: 14.sp,
                        color: const Color(0xff252525),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── How to Attend ─────────────────────────────────
                    const SectionHeader(title: 'How to attend'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          _attendRow(
                            icon: isOnline
                                ? Icons.videocam_outlined
                                : Icons.meeting_room_outlined,
                            text: isOnline
                                ? 'Join online${liveProvider.isNotEmpty ? ' via $liveProvider' : ''}'
                                : 'Attend in person',
                          ),
                          if (isOnline && liveStatus.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            _attendRow(
                              icon: liveStatus == 'LIVE'
                                  ? Icons.circle
                                  : Icons.access_time,
                              iconColor: liveStatus == 'LIVE'
                                  ? const Color(0xffE53935)
                                  : const Color(0xff757575),
                              text: liveStatus == 'LIVE'
                                  ? 'Session is currently LIVE'
                                  : 'Status: $liveStatus',
                            ),
                          ],
                          if (isOnline) ...[
                            SizedBox(height: 12.h),
                            _attendRow(
                              icon: Icons.desktop_mac_outlined,
                              text:
                                  'Open the app and tap "Join" when the session starts',
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Speakers ──────────────────────────────────────
                    Obx(() {
                      final profiles = controller.speakerProfiles;
                      if (profiles.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: 'Speakers'),
                          Container(
                            width: 345.w,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: const Color(0x66EFEFF0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r),
                              ),
                            ),
                            child: Column(
                              children: profiles.map((sp) {
                                final accountId =
                                    sp['accountId']?.toString() ?? '';
                                final affiliations =
                                    sp['affiliations'] as List?;
                                final company = affiliations != null &&
                                        affiliations.isNotEmpty
                                    ? (affiliations.first
                                            as Map<String, dynamic>)['company']
                                        ?.toString() ??
                                        ''
                                    : '';
                                return SpeakerCard(
                                  name: sp['name']?.toString() ?? 'Speaker',
                                  role: sp['sessionRole']?.toString() ?? '',
                                  company: company,
                                  imagePath: sp['avatar']?.toString() ?? '',
                                  about: sp['about']?.toString() ?? '',
                                  onTap: () =>
                                      controller.openSpeakerDetails(
                                    context,
                                    accountId,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendRow({
    required IconData icon,
    required String text,
    Color iconColor = const Color(0xff252525),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomText(
            textAlign: TextAlign.start,
            text: text,
            fontsize: 14.sp,
            color: const Color(0xff252525),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String? isoDate, String? time) {
    String datePart = '';
    if (isoDate != null && isoDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(isoDate);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        datePart = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {
        datePart = isoDate;
      }
    }
    if (time != null && time.isNotEmpty) {
      return datePart.isNotEmpty ? '$datePart · $time' : time;
    }
    return datePart.isNotEmpty ? datePart : 'Date not available';
  }
}
