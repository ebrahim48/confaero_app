import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';

class EventSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const EventSearchBar({
    super.key,
    required this.controller,
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
        border: Border.all(color: const Color(0xffD2D2D2)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textColor424242),
        decoration: InputDecoration(
          hintText: 'Search event name, Location, etc',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textColor7E7F7E,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 18.w,
              height: 18.h,
              colorFilter: ColorFilter.mode(
                AppColors.textColor7E7F7E,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}