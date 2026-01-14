import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const EventTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: const Color(0xffD2D2D2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab('My Events', 0),
          ),
          Expanded(
            child: _buildTab('Explore Events', 1),
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
        height: 42.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff5BB8AE) : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Center(
          child: CustomText(
            text: title,
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.textColorFFFFFF
                : AppColors.textColor424242,
          ),
        ),
      ),
    );
  }
}