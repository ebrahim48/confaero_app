import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor424242,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
          ),
        ],
      ),
    );
  }
}