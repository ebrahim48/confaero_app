import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';


class AboutEventCard extends StatelessWidget {
  final String description;
  final VoidCallback onSeeMore;

  const AboutEventCard({
    super.key,
    required this.description,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: Border.all(
          color: const Color(0xffD2D2D2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F454545),
            blurRadius: 8,
            offset: const Offset(1, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'About Event',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor424242,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: description,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
            textAlign: TextAlign.start,
            maxline: 6,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onSeeMore,
            child: CustomText(
              text: 'See More',
              fontsize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff5BB8AE),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}