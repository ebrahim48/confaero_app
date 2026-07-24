import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class PhotoFilterChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const PhotoFilterChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28.h,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor32A69A : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor32A69A
                : AppColors.borderColorD2D2D2,
            width: 1,
          ),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppColors.textColorFFFFFF
                : AppColors.textColor252525,
          ),
        ),
      ),
    );
  }
}