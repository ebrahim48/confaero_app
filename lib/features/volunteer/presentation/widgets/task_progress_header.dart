import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class TaskProgressHeader extends StatelessWidget {
  final double percent;
  final int completed;
  final int total;
  final int remaining;

  const TaskProgressHeader({
    super.key,
    required this.percent,
    required this.completed,
    required this.total,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Progress",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor252525)),
          SizedBox(height: 2.h),
          Text("You're doing great! Keep it up.",
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textColor7E7F7E)),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8.h,
                    backgroundColor: const Color(0xffE0E0E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xff32A69A)),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor252525),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completed of $total tasks completed',
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textColor7E7F7E)),
              Text('$remaining remaining',
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textColor7E7F7E)),
            ],
          ),
        ],
      ),
    );
  }
}