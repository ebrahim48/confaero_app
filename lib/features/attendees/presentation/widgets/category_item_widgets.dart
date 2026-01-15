import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';


class CategoryItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xffD2D2D2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 32.w,
              height: 32.h,
              colorFilter: ColorFilter.mode(
                AppColors.textColor424242,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomText(
                text: label,
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor424242,
                textAlign: TextAlign.center,
                maxline: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}