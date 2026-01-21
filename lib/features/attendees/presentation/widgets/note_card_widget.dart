
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    required this.title,
    required this.date,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 345.w,
        height: 71.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(7.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xff9E9E9E).withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Edit Icon Container
            Container(
              width: 57.w,
              height: 57.h,
              decoration: BoxDecoration(
                color: const Color(0xffE1E1E1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/editicon.svg',
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Title and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor424242,
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: date,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9E9E9E),
                  ),
                ],
              ),
            ),

            // Chevron Icon
            SvgPicture.asset(
              'assets/icons/chevronright.svg',
              width: 20.w,
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}