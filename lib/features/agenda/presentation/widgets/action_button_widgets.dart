import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? borderColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: borderColor ?? const Color(0xffD2D2D2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: iconColor ?? const Color(0xff252525),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: text,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff252525),
            ),
          ],
        ),
      ),
    );
  }
}