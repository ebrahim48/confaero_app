import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class DocumentItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fileSize;
  final String iconPath;
  final VoidCallback onTap;
  final bool showArrow;

  const DocumentItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileSize,
    required this.iconPath,
    required this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                // PDF Icon
                Image.asset(
                  iconPath,
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(width: 12.w),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: subtitle,
                        fontsize: 12.sp,
                        color: const Color(0xff757575),
                        maxline: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // File Size and Action
                GestureDetector(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        CustomText(
                          text: 'View',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff32A69A),
                        ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: fileSize,
                        fontsize: 12.sp,
                        color: const Color(0xff9E9E9E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divider
        Container(
          height: 0.5.h,
          color: const Color(0xffD2D2D2),
        ),
      ],
    );
  }
}