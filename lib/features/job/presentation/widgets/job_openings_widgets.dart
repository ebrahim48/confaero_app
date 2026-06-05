import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../attendees/presentation/controllers/job_openings_controller.dart';
import 'view/post_a_job_screen.dart';

class JobOpeningsFab extends StatelessWidget {
  const JobOpeningsFab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PostAJobScreen()),
        );
        if (result == true) {
          Get.find<JobOpeningsController>().refreshJobs();
        }
      },
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: const Color(0xff5BB8AE),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffD2D2D2), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3321676033),
              blurRadius: 8,
              offset: Offset(2, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 32.sp,
            color: const Color(0xffF6F6F6),
          ),
        ),
      ),
    );
  }
}

class JobListShimmer extends StatelessWidget {
  const JobListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 40.w, height: 40.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14.h, width: 140.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                        SizedBox(height: 6.h),
                        Container(height: 11.h, width: 100.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                      ],
                    ),
                  ),
                  Container(height: 14.h, width: 60.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
                ],
              ),
              SizedBox(height: 12.h),
              Container(height: 11.h, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
              SizedBox(height: 6.h),
              Container(height: 11.h, width: 180.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Container(height: 24.h, width: 70.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  SizedBox(width: 8.w),
                  Container(height: 24.h, width: 70.w, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
