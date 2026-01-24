import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class TabToggleButton extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;
  final String leftText;
  final String rightText;

  const TabToggleButton({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.leftText = 'All Sessions',
    this.rightText = 'My Agenda',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: const Color(0xffD2D2D2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left Button
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(0),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? const Color(0xff5BB8AE)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: CustomText(
                    text: leftText,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 0
                        ? Colors.white
                        : const Color(0xff252525),
                  ),
                ),
              ),
            ),
          ),

          // Right Button
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(1),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? const Color(0xff5BB8AE)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: CustomText(
                    text: rightText,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 1
                        ? Colors.white
                        : const Color(0xff252525),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}