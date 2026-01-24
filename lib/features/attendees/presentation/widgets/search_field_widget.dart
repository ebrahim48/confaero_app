import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const SearchFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 38.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF252525),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: const Color(0xFF999999),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
        ),
      ),
    );
  }
}