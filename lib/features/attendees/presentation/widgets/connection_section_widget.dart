import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConnectSectionWidget extends StatelessWidget {
  final String website;
  final String email;

  const ConnectSectionWidget({
    super.key,
    required this.website,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF252525),
          ),
        ),
        SizedBox(height: 12.h),

        // Website
        _buildConnectItem(
          icon: 'assets/icons/weblink.svg',
          title: 'Website',
          value: website,
          onTap: () {},
        ),

        SizedBox(height: 12.h),

        // Email
        _buildConnectItem(
          icon: 'assets/icons/email.svg',
          title: 'Email',
          value: email,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildConnectItem({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 346.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFD2D2D2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              color: const Color(0xFF252525),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7E7F7E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/chevronright.svg',
              width: 20.w,
              height: 20.h,
              color: const Color(0xFF252525),
            ),
          ],
        ),
      ),
    );
  }
}