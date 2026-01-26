import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../presentations/widgets/custom_text.dart';

class ActionButton extends StatelessWidget {
  final String svgIcon; // 🔥 svg path
  final String text;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? borderColor;

  const ActionButton({
    super.key,
    required this.svgIcon,
    required this.text,
    required this.onTap,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: borderColor ?? AppColors.primaryColor32A69A,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              width: 18.w,
              height: 18.h,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: text,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff252525),
            ),
          ],
        ),
      ),
    );
  }
}
