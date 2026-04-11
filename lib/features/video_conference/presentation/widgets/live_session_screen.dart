import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/role_controller.dart';
import '../../../../core/services/socket_service.dart';
import '../controllers/event_live_controller.dart';
import '../controllers/video_conference_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';
import 'live_chat_screen.dart';
import 'live_poll_widget.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoConferenceController());
    final eventLiveCtrl = Get.put(EventLiveController());
    final socketService = Get.find<SocketService>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Live Sessions'),

          // Socket connection status
          Obx(() {
            if (!socketService.isConnected.value) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, size: 16.sp, color: Colors.orange),
                    SizedBox(width: 8.w),
                    Text(
                      'Connecting to live session...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

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
                    final sessionIndex = index + 1; // 1-based index

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
                                // Join video session
                                _actionBtn('Join', const Color(0xff32A69A), () {
                                  controller.joinSession(
                                    session['_id'] as String? ?? '',
                                  );
                                }),
                                SizedBox(width: 8.w),
                                // Open live chat
                                _actionBtn('Chat', Colors.blue, () {
                                  Get.to(
                                    () => LiveChatScreen(sessionIndex: sessionIndex),
                                  );
                                }),
                                SizedBox(width: 8.w),
                                // End session (speaker only)
                                if (RoleController.to.isRole('SPEAKER'))
                                  _actionBtn('End', Colors.red, () {
                                    _showEndSessionDialog(
                                      context,
                                      eventLiveCtrl,
                                      sessionIndex,
                                    );
                                  }),
                              ],
                            ],
                          ),

                          // Live session features section (only for live sessions)
                          if (status == 'live') ...[
                            SizedBox(height: 12.h),
                            Divider(color: Colors.grey.shade200),
                            SizedBox(height: 8.h),
                            _LiveSessionFeatures(sessionIndex: sessionIndex),
                          ],
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

  void _showEndSessionDialog(
    BuildContext context,
    EventLiveController controller,
    int sessionIndex,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this live session?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.currentSessionIndex.value = sessionIndex;
              controller.endSession();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('End Session'),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 13.sp),
      ),
    );
  }
}

/// Widget showing live session features (polls, speaker controls)
class _LiveSessionFeatures extends StatelessWidget {
  final int sessionIndex;

  const _LiveSessionFeatures({required this.sessionIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventLiveController>();
    final isSpeaker = RoleController.to.isRole('SPEAKER');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Features header
        Row(
          children: [
            Icon(Icons.live_tv, size: 16.sp, color: const Color(0xFF32A69A)),
            SizedBox(width: 6.w),
            Text(
              'Live Features',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF32A69A),
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Speaker-only controls
        if (isSpeaker) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              // Create poll button
              _featureBtn(
                icon: Icons.add_chart,
                label: 'Create Poll',
                color: Colors.purple,
                onTap: () => _showCreatePollDialog(context, sessionIndex),
              ),
              // Mute all button
              _featureBtn(
                icon: Icons.mic_off,
                label: 'Mute All',
                color: Colors.orange,
                onTap: () {
                  controller.currentSessionIndex.value = sessionIndex;
                  controller.muteAllAttendees();
                },
              ),
              // Unmute all button
              _featureBtn(
                icon: Icons.mic,
                label: 'Unmute All',
                color: Colors.green,
                onTap: () {
                  controller.currentSessionIndex.value = sessionIndex;
                  controller.unmuteAllAttendees();
                },
              ),
            ],
          ),
        ],

        // Active polls
        Obx(() {
          final polls = controller.polls;
          if (polls.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                isSpeaker ? 'Create a poll to engage attendees' : 'No active polls',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: polls
                .map((poll) => LivePollWidget(poll: poll, sessionIndex: sessionIndex))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _featureBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16.sp, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(fontSize: 12.sp, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _showCreatePollDialog(BuildContext context, int sessionIndex) {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Poll creation is available in the live chat screen',
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => LiveChatScreen(sessionIndex: sessionIndex));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF32A69A),
                ),
                child: const Text('Open Live Chat'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

