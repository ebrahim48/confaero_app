import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/video_conference_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoConferenceController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Live Sessions'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.sessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off,
                        size: 64.r,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No live sessions',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadSessions,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    final session = controller.sessions[index];
                    final status = session['status'] as String? ?? 'scheduled';
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFD7EAE8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0D000000),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                status == 'live'
                                    ? Icons.fiber_manual_record
                                    : Icons.videocam,
                                color:
                                    status == 'live'
                                        ? Colors.red
                                        : const Color(0xff32A69A),
                                size: 18.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  session['title'] as String? ?? 'Session',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      status == 'live'
                                          ? Colors.red.withAlpha(25)
                                          : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  status == 'live'
                                      ? 'LIVE'
                                      : status.capitalize!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        status == 'live'
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              if (status == 'scheduled')
                                _actionBtn(
                                  'Start',
                                  const Color(0xff32A69A),
                                  () {
                                    controller.startSession(
                                      session['_id'] as String? ?? '',
                                    );
                                  },
                                ),
                              if (status == 'live') ...[
                                _actionBtn('Join', const Color(0xff32A69A), () {
                                  controller.joinSession(
                                    session['_id'] as String? ?? '',
                                  );
                                }),
                                SizedBox(width: 8.w),
                                _actionBtn('End', Colors.red, () {
                                  controller.endSession(
                                    session['_id'] as String? ?? '',
                                  );
                                }),
                              ],
                            ],
                          ),
                        ],
                      ),
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

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 13.sp),
      ),
    );
  }
}
