import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpecialOfferWidget extends StatelessWidget {
  final String offer;

  const SpecialOfferWidget({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 346.w,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F5),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/penciloffer.svg',
            width: 24.w,
            height: 24.h,
            color: const Color(0xFF73AAA6),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SPECIAL OFFER',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF73AAA6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                offer,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF252525),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}