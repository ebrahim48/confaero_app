// ==========================================
// FILE 3: announcement_card_widget.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../announcements/data/models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              announcement.createdAt, // Real date
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.h),

            // Main Content
            Row(
              children: [
                // Icon Container
                _buildIconContainer(),
                SizedBox(width: 12.w),

                // Text Content
                Expanded(child: _buildTextContent()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.campaign, color: Colors.black, size: 20.r),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          announcement.title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
