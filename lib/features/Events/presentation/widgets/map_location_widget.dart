import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class MapLocationCard extends StatelessWidget {
  final String locationName;
  final VoidCallback onTap;

  const MapLocationCard({
    super.key,
    required this.locationName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 349.w,
        height: 98.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.grey[300],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0x66000000).withValues(alpha: 0.4),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: const Color(0xffF6F6F6),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: locationName,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffF6F6F6),
                  textAlign: TextAlign.start,
                  textDecoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}