import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF32A69A) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: 2.h,
              left: value ? 18.w : 2.w,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(78.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0F000000),
                      blurRadius: 0.78,
                      offset: const Offset(0, 2.35),
                    ),
                    BoxShadow(
                      color: const Color(0x26000000),
                      blurRadius: 6.27,
                      offset: const Offset(0, 2.35),
                    ),
                    BoxShadow(
                      color: const Color(0x0A000000),
                      blurRadius: 0,
                      spreadRadius: 0.78,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}