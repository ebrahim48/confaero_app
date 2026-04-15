import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final List<String> tabLabels;

  const EventTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    this.tabLabels = const ['My Events', 'Explore Events'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: const Color(0xffD2D2D2)),
      ),
      child: Row(
        children: tabLabels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return Expanded(
            child: _buildTab(label, index),
          );
        }).toList(),
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