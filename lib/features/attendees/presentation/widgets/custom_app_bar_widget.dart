import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class CustomAppBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 98.h,
      color: const Color(0xffF5F5F5),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColors.textColor424242,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomText(
                textAlign: TextAlign.start,
                text: title,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),
            ),
          ],
        ),
      ),
    );
  }
}