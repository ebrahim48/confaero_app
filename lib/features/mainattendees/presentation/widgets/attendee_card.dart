import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class AttendeeCard extends StatelessWidget {
  final String name;
  final String company;
  final String role;
  final String sessions;
  final String imagePath;
  final bool isBookmarked;
  final bool isOnline;
  final VoidCallback onBookmarkTap;
  final VoidCallback onSayHi;
  final VoidCallback onSendMail;
  final VoidCallback onTap;

  const AttendeeCard({
    super.key,
    required this.name,
    required this.company,
    required this.role,
    required this.sessions,
    required this.imagePath,
    required this.isBookmarked,
    this.isOnline = false,
    required this.onBookmarkTap,
    required this.onSayHi,
    required this.onSendMail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345.w,
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xff9E9E9E),
            width: 0.3,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              blurRadius: 4,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Avatar, Info, Bookmark
            Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    Container(
                      width: 45.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: imagePath.startsWith('http://') || imagePath.startsWith('https://')
                              ? NetworkImage(imagePath)
                              : AssetImage(imagePath) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Online status indicator (green dot)
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),

                // Name and Company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: company,
                        fontsize: 12.sp,
                        color: const Color(0xff757575),
                      ),
                    ],
                  ),
                ),

                // Bookmark Icon
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    isBookmarked ? Icons.star : Icons.star_border,
                    size: 24.sp,
                    color: isBookmarked
                        ? const Color(0xffFFC107)
                        : const Color(0xff252525),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Role and Sessions
            Row(
              children: [
                // Role Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CustomText(
                    text: role,
                    fontsize: 12.sp,
                    color: const Color(0xff252525),
                  ),
                ),
                SizedBox(width: 8.w),

                // Sessions
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14.sp,
                  color: const Color(0xff757575),
                ),
                SizedBox(width: 4.w),
                CustomText(
                  text: sessions,
                  fontsize: 12.sp,
                  color: const Color(0xff757575),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Divider
            Container(
              height: 0.5.h,
              color: const Color(0xff9E9E9E),
            ),
            SizedBox(height: 12.h),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Say Hi Button
                Expanded(
                  child: GestureDetector(
                    onTap: onSayHi,
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffD7EAE8),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16.sp,
                            color: const Color(0xff252525),
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: 'Say Hi',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff252525),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Send Mail Button
                Expanded(
                  child: GestureDetector(
                    onTap: onSendMail,
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 16.sp,
                            color: const Color(0xff252525),
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: 'Send Mail',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff252525),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}