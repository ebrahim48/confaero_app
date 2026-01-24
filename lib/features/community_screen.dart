import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Community',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Announcement List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  _buildAnnouncementCard(
                    icon: Icons.campaign,
                    iconColor: Colors.black,
                    backgroundColor: const Color(0xFFE8F5E9),
                    title: 'Last day registration Announceme...',
                    subtitle: 'Official update from event by',
                    organizer: '(Organizer)',
                    date: 'Last Announcement made 4, Dec 2025',
                  ),
                  SizedBox(height: 12.h),
                  _buildAnnouncementCard(
                    icon: Icons.help_outline,
                    iconColor: Colors.black,
                    backgroundColor: const Color(0xFFFFF3E0),
                    title: 'Ask Organizers Anything',
                    subtitle: 'Have questions? Ask here',
                    organizer: null,
                    date: 'Last Announcement made 4, Dec 2025',
                    secondaryIcon: Icons.push_pin,
                  ),
                  SizedBox(height: 12.h),
                  _buildAnnouncementCard(
                    icon: Icons.campaign,
                    iconColor: Colors.black,
                    backgroundColor: const Color(0xFFE8F5E9),
                    title: 'Last day registration Announceme...',
                    subtitle: 'Official update from event by',
                    organizer: '(Organizer)',
                    date: 'Last Announcement made 4, Dec 2025',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    String? organizer,
    required String date,
    IconData? secondaryIcon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Text(
            date,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),

          // Main Content
          Row(
            children: [
              // Icon Container
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (organizer != null) ...[
                          SizedBox(width: 4.w),
                          Text(
                            organizer,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Secondary Icon (if any)
              if (secondaryIcon != null)
                Icon(
                  secondaryIcon,
                  color: Colors.grey[600],
                  size: 20.r,
                ),
            ],
          ),
        ],
      ),
    );
  }
}