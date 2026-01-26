// ==========================================
// FILE 3: announcement_card_widget.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/announcement_model.dart';

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
              announcement.date,
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
                Expanded(
                  child: _buildTextContent(),
                ),

                // Secondary Icon (if any)
                if (announcement.secondaryIcon != null)
                  _buildSecondaryIcon(),
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
        color: announcement.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        announcement.icon,
        color: announcement.iconColor,
        size: 20.r,
      ),
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
            Text(
              announcement.subtitle,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            if (announcement.organizer != null) ...[
              SizedBox(width: 4.w),
              Text(
                announcement.organizer!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryIcon() {
    return Icon(
      announcement.secondaryIcon,
      color: Colors.grey[500],
      size: 18.r,
    );
  }
}