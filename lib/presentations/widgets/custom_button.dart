import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final Color? titlecolor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool loading;
  final bool loaderIgnore;
  final Widget? prefixIcon;

  CustomButton({
    super.key,
    required this.title,
    this.borderColor,
    required this.onpress,
    this.color,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.prefixIcon,
    this.loading = false,
    this.loaderIgnore = false,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? () {} : onpress,
      child: Container(
        width: width?.w ?? double.infinity,
        height: height ?? 54.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          border: Border.all(
            color: borderColor ?? AppColors.primaryColor32A69A,
          ),
          color: color ?? AppColors.primaryColor32A69A,
        ),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        //   border: Border.all(color: AppColors.primaryColor9F7F5F),
        //   color: color ?? AppColors.primaryColor9F7F5F,
        // ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loaderIgnore ? const SizedBox() : SizedBox(width: 30.w),
            Center(
              child: CustomText(
                text: title,
                fontsize: fontSize ?? 14.h,
                color: titlecolor ?? AppColors.textColorFFFFFF,
                fontWeight: fontWeight ?? FontWeight.w700,
              ),
            ),
            loaderIgnore ? const SizedBox() : SizedBox(width: 20.w),
            loaderIgnore
                ? const SizedBox()
                : loading
                    ? SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: Assets.lottie.buttonLoading
                            .lottie(fit: BoxFit.cover))
                    : SizedBox(width: 25.w)
          ],
        ),
      ),
    );
  }
}
