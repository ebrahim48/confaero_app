import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';


class QrInfoItem extends StatelessWidget {
  final String icon;
  final String text;

  const QrInfoItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              AppColors.textColor424242,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: text,
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor424242,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}