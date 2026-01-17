import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff32A69A) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xffD2D2D2),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textColor424242,
          ),
        ),
      ),
    );
  }
}