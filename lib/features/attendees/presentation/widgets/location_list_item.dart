import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class LocationListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const LocationListItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 16.h,
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor424242,
            ),
            SvgPicture.asset(
              'assets/icons/chevronright.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                AppColors.textColor424242,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}