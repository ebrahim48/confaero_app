import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 38.h,
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: const Color(0xffD2D2D2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xff252525),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: const Color(0xff9E9E9E),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xff9E9E9E),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}