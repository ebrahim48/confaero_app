import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class TabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const TabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 36.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.topNavbarColorF5F5F5,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: const Color(0xffF5F6F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 5,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gap = 1.w;
          final pillWidth = (constraints.maxWidth - gap) / 2;
          final pillHeight = constraints.maxHeight;

          return Stack(
            children: [
              // Sliding indicator pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                left: selectedTab == 0 ? 0 : pillWidth + gap,
                top: 0,
                width: pillWidth,
                height: pillHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0x80EFF0F6)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 2,
                        offset: Offset(0, -2),
                        spreadRadius: 0,
                        blurStyle: BlurStyle.inner,
                      ),
                      BoxShadow(
                        color: Color(0x3DE4E5E7),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab labels on top of the pill
              Row(
                children: [
                  Expanded(child: _buildLabel('Log In', 0)),
                  SizedBox(width: gap),
                  Expanded(child: _buildLabel('Sign Up', 1)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 36.h,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColors.textColor424242
                  : AppColors.textColor424242.withValues(alpha: 0.6),
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
