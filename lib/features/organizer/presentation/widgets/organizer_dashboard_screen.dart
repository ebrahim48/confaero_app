import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/controllers/session_controller.dart';
import '../controllers/organizer_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrganizerController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Organizer Dashboard'),

          // Quick Access Management Tiles
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF252525),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _QuickTile(
                      icon: Icons.campaign_outlined,
                      label: 'Announcements',
                      color: const Color(0xFF32A69A),
                      onTap: () {
                        final eventId = SessionController.to.eventId;
                        context.pushNamed(
                          AppRoutes.organizerAnnouncementsCrudScreen,
                          extra: eventId,
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    _QuickTile(
                      icon: Icons.quiz_outlined,
                      label: 'Q&A / Survey',
                      color: const Color(0xFF6C63FF),
                      onTap: () {
                        final eventId = SessionController.to.eventId;
                        context.pushNamed(
                          AppRoutes.organizerResourcesCrudScreen,
                          extra: eventId,
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    _QuickTile(
                      icon: Icons.mail_outline,
                      label: 'Invite Emails',
                      color: const Color(0xFFE07B39),
                      onTap: () {
                        final eventId = SessionController.to.eventId;
                        context.pushNamed(
                          AppRoutes.verifiedEmailScreen,
                          extra: eventId,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _QuickTile(
                      icon: Icons.people_alt_outlined,
                      label: 'Attendees',
                      color: const Color(0xFF2196F3),
                      onTap: () {
                        final eventId = SessionController.to.eventId;
                        context.pushNamed(
                          AppRoutes.organizerAttendeeScreen,
                          extra: eventId,
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    _QuickTile(
                      icon: Icons.chat_bubble_outline,
                      label: 'Messages',
                      color: const Color(0xFF4CAF50),
                      onTap:
                          () => context.pushNamed(
                            AppRoutes.organizerConversationsScreen,
                          ),
                    ),
                    SizedBox(width: 10.w),
                    _QuickTile(
                      icon: Icons.mark_email_read_outlined,
                      label: 'Invitations',
                      color: const Color(0xFFE91E63),
                      onTap:
                          () => context.pushNamed(AppRoutes.invitationsScreen),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1.h, color: const Color(0xFFEEEEEE)),

          // Sessions header with add button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  'Sessions',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF252525),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.sessionFormScreen),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff32A69A),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 16),
                        SizedBox(width: 4.w),
                        Text(
                          'Add Session',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sessions list
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
                        Icons.event_note,
                        size: 64.r,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No sessions yet',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap "Add Session" to create one',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade400,
                        ),
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
                    return _SessionCard(
                      session: session,
                      onEdit: () {
                        controller.populateForm(session);
                        context.pushNamed(
                          AppRoutes.sessionFormScreen,
                          extra: session,
                        );
                      },
                      onDelete:
                          () => _confirmDelete(
                            context,
                            controller,
                            session['_id'] as String? ?? '',
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

  void _confirmDelete(
    BuildContext context,
    OrganizerController controller,
    String id,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Session'),
            content: const Text(
              'Are you sure you want to delete this session?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.deleteSession(id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

/// A compact square tile for quick navigation actions.
class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24.r),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SessionCard({
    required this.session,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  session['title'] as String? ?? 'Untitled',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF252525),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                itemBuilder:
                    (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (session['description'] != null)
            Text(
              session['description'] as String,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF7E7F7E)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14.r,
                color: const Color(0xff32A69A),
              ),
              SizedBox(width: 4.w),
              Text(
                '${session['startTime'] ?? ''} - ${session['endTime'] ?? ''}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff32A69A),
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.location_on, size: 14.r, color: Colors.grey),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  session['location'] as String? ?? '',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
