import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';

class CheckInCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final String description;
  final VoidCallback onButtonPressed;
  final VoidCallback onContactTap;
  final bool isPrimary;

  const CheckInCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.description,
    required this.onButtonPressed,
    required this.onContactTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        CustomButton(
          title: buttonText,
          onpress: onButtonPressed,
          color: isPrimary ? const Color(0xff32A69A) : Colors.transparent,
          titlecolor: isPrimary ? Colors.white : const Color(0xff32A69A),
          borderColor: const Color(0xff32A69A),
          height: 48.h,
          borderRadius: 8.r,
        ),
        SizedBox(height: 12.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              height: 1.5,
            ),
            children: [
              TextSpan(text: description),
              TextSpan(
                text: ' contact us',
                style: TextStyle(
                  color: const Color(0xff32A69A),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = onContactTap,
              ),
              const TextSpan(text: ' immediately.'),
            ],
          ),
        ),
      ],
    );
  }
}