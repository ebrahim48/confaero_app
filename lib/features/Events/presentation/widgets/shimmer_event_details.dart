import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEventDetails extends StatelessWidget {
  const ShimmerEventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner placeholder
            Container(
              width: double.infinity,
              height: 190.h,
              color: Colors.white,
            ),

            SizedBox(height: 24.h),

            // Event info card placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Container(
                    width: 84.w,
                    height: 84.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(double.infinity, 14.h),
                        SizedBox(height: 6.h),
                        _box(160.w, 14.h),
                        SizedBox(height: 10.h),
                        _box(100.w, 12.h),
                        SizedBox(height: 6.h),
                        _box(80.w, 12.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Map placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                height: 98.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Description title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(160.w, 18.h),
                  SizedBox(height: 12.h),
                  _box(double.infinity, 12.h),
                  SizedBox(height: 6.h),
                  _box(double.infinity, 12.h),
                  SizedBox(height: 6.h),
                  _box(double.infinity, 12.h),
                  SizedBox(height: 6.h),
                  _box(200.w, 12.h),
                  SizedBox(height: 16.h),
                  _box(60.w, 14.h),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Register button placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double width, double height, {double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}