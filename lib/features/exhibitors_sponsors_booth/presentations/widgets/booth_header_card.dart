import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';


class BoothHeaderCard extends StatelessWidget {
  final bool hasBooth;
  final String boothName;
  final String boothLocation;
  final String boothStatus;
  final VoidCallback onCreateTap;
  final VoidCallback onEditTap;

  const BoothHeaderCard({
    super.key,
    required this.hasBooth,
    required this.boothName,
    required this.boothLocation,
    required this.boothStatus,
    required this.onCreateTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: hasBooth ? _boothFilledCard() : _boothEmptyCard(),
    );
  }

  Widget _boothEmptyCard() {
    return Row(
      children: [
        Container(
          width: 80.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: const Color(0xff3D3535),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: GestureDetector(
            onTap: onCreateTap,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor32A69A,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Create Booth',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        // decorative icon placeholder
        Opacity(
          opacity: 0.15,
          child: Icon(Icons.business_center,
              size: 40.sp, color: AppColors.textColor7E7F7E),
        ),
      ],
    );
  }

  Widget _boothFilledCard() {
    return Row(
      children: [
        Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: const Color(0xffEAE8F5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Image.asset('assets/images/booth.png', fit: BoxFit.contain),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boothName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor252525,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                boothLocation,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textColor7E7F7E,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
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
                      boothStatus,
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
        GestureDetector(
          onTap: onEditTap,
          child: SvgPicture.asset(
            'assets/icons/edit.svg',
            width: 18.w,
            height: 18.h,
            colorFilter: const ColorFilter.mode(
                AppColors.primaryColor32A69A, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}