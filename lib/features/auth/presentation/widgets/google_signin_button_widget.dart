import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 345.w,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.textColorFFFFFF,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.borderColorD2D2D2.withValues(alpha: 0.4)),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.textColor424242,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: 'Continue with Google',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
      ),
    );
  }
}