import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Sessions section — CRUD endpoints removed from backend
          Expanded(
            child: Center(
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
                    'Session management coming soon',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
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

