import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventInfoChipWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isPrimary;

  const EventInfoChipWidget({
    super.key,
    required this.icon,
    required this.text,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF32A69A) : Colors.transparent,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: isPrimary ? const Color(0xFF32A69A) : const Color(0xFFD2D2D2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: isPrimary ? Colors.white : const Color(0xFF666666),
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: text,
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isPrimary ? Colors.white : const Color(0xFF666666),
          ),
        ],
      ),
    );
  }
}