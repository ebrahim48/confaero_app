import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffD7EAE8) : const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff252525),
          ),
        ),
      ),
    );
  }
}