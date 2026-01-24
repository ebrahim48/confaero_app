import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class DaySelector extends StatelessWidget {
  final String day;
  final int date;
  final bool isSelected;
  final VoidCallback onTap;

  const DaySelector({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomText(
            text: day,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff757575),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSelected
                  ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff0FC3C2), Color(0xff06B6B4)],
              )
                  : null,
              color: isSelected ? null : const Color(0xffF5F5F5),
            ),
            child: Center(
              child: CustomText(
                text: date.toString(),
                fontsize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xff252525),
              ),
            ),
          ),
        ],
      ),
    );
  }
}