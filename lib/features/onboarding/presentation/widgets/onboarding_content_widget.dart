import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),
        Image.asset(
          'assets/images/logo.png',
          width: 181.w,
          height: 90.h,
        ),

        // Illustration
        Image.asset(
          image,
          width: 345.w,
          height: 272.h,
          fit: BoxFit.contain,
        ),

        SizedBox(height: 20.h),

        // Title and Description
        SizedBox(
          width: 320.w,
          child: Column(
            children: [
              CustomText(
                text: title,
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor252525,
                textAlign: TextAlign.center,
                maxline: 2,
              ),

              SizedBox(height: 12.h),

              CustomText(
                text: description,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor424242,
                textAlign: TextAlign.center,
                maxline: 4,
                textHeight: 1.5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}