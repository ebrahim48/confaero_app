import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

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
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab('Log In', 0),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: _buildTab('Sign Up', 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        height: 34.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textColorFFFFFF : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: isSelected
              ? Border.all(color: const Color(0x80EFF0F6))
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0x08000000),
              blurRadius: 2,
              offset: const Offset(0, -2),
              spreadRadius: 0,
              blurStyle: BlurStyle.inner,
            ),
            BoxShadow(
              color: const Color(0x3DE4E5E7),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ]
              : null,
        ),
        child: Center(
          child: CustomText(
            text: title,
            fontsize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.textColor424242
                : AppColors.textColor424242.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}