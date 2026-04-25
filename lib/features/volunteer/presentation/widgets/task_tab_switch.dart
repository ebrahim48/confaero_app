import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class TaskTabSwitch extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onSelect;

  const TaskTabSwitch({
    super.key,
    required this.selectedTab,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            _tab('Current Task'),
            _tab('Task History'),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label) {
    final isSelected = selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor32A69A
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppColors.textColor7E7F7E,
              ),
            ),
          ),
        ),
      ),
    );
  }
}