import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class FilterChipButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipButton({
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff32A69A) : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: const Color(0xffD2D2D2),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontsize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xff252525),
          ),
        ),
      ),
    );
  }
}