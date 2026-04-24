import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';

class SponsorHeaderCard extends StatelessWidget {
  final bool hasProfile;
  final String displayName;
  final String description;
  final String status;
  final String logoPath;
  final VoidCallback onEditTap;

  const SponsorHeaderCard({
    super.key,
    required this.hasProfile,
    required this.displayName,
    required this.description,
    required this.status,
    required this.logoPath,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:
        Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
            ),
            child: logoPath.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(logoPath, fit: BoxFit.contain),
            )
                : Image.asset(
              'assets/images/booth.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor252525,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F8F2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.h,
                        decoration: const BoxDecoration(
                          color: Color(0xff2DB87D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xff2DB87D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Edit icon
          GestureDetector(
            onTap: onEditTap,
            child: SvgPicture.asset(
              'assets/icons/edit.svg',
              width: 18.w,
              height: 18.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor32A69A,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}