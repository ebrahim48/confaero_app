
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final double? height;
  final int? maxLength;

  const MultiLineTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 4,
    this.height,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: height ?? 90.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xff9E9E9E),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xff252525),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.w),
          hintText: hintText ?? '',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xff9E9E9E),
          ),
          counterText: '', // Hide counter
        ),
      ),
    );
  }
}