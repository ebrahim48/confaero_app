import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoothInfoWidget extends StatelessWidget {
  final String boothNumber;
  final String openingHours;

  const BoothInfoWidget({
    super.key,
    required this.boothNumber,
    required this.openingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Booth Number Card
        Expanded(
          child: _buildInfoCard(
            icon: 'assets/icons/booth.svg',
            title: 'Booth Number',
            value: boothNumber,
          ),
        ),
        SizedBox(width: 16.w),

        // Opening Hours Card
        Expanded(
          child: _buildInfoCard(
            icon: 'assets/icons/booth.svg',
            title: 'Opening Hours',
            value: openingHours,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: 165.w,
      height: 160.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.h,
                color: const Color(0xFF73AAA6),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7E7F7E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF252525),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}