import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;

  const FormInputWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: maxLines > 1
          ? BoxConstraints(minHeight: 147.h)
          : BoxConstraints(maxHeight: 44.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xff9E9E9E),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff9E9E9E),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }
}