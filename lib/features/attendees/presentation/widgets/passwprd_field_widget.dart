import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordFieldWidget extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const PasswordFieldWidget({
    super.key,
    required this.hint,
    required this.controller,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE1E1E1),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF999999),
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}