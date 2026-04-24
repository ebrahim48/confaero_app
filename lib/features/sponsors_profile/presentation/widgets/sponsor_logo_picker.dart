import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class SponsorLogoPicker extends StatelessWidget {
  final String logoPath;
  final VoidCallback onTap;

  const SponsorLogoPicker({
    super.key,
    required this.logoPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: logoPath.isNotEmpty ? _logoFilled() : _logoEmpty(),
    );
  }

  Widget _logoEmpty() {
    return Container(
      width: double.infinity,
      height: 130.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.borderColorD2D2D2,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined,
              size: 30.sp, color: AppColors.textColor7E7F7E),
          SizedBox(height: 8.h),
          Text(
            'Upload your logo',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor424242,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Recommended Size 1200*600px (16:9)',
            style: TextStyle(
                fontSize: 10.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  Widget _logoFilled() {
    return Container(
      width: double.infinity,
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderColorD2D2D2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }
}