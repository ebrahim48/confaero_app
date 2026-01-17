import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/job_openings_controller.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobCardWidget({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xffD2D2D2),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section with Background Image
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/jobopenings.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.28, 0.66, 0.85],
                        colors: [
                          const Color(0xFFFFFFFF).withValues(alpha:0.95),
                          const Color(0xBFEFEFEF).withValues(alpha:0.75),
                          const Color(0x26999999).withValues(alpha:0.15),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(14.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Name
                          CustomText(
                            textAlign: TextAlign.start,
                            text: job.companyName,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                          SizedBox(height: 6.h),

                          // Position & Job Type
                          Row(
                            children: [
                              CustomText(
                                textAlign: TextAlign.start,
                                text: job.position,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor424242,
                              ),
                              SizedBox(width: 23.w),
                              Icon(
                                Icons.work_outline,
                                size: 12.sp,
                                color: AppColors.textColor424242,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: job.jobType,
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor424242,
                              ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14.sp,
                                color: AppColors.textColor7E7F7E,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: CustomText(
                                  textAlign: TextAlign.start,
                                  text: job.location,
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor7E7F7E,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.h),

                          // Last Date
                          CustomText(
                            text: 'Last Date : ${job.lastDate}',
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor7E7F7E,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section - Applicants & Salary
            Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Applicants
                  CustomText(
                    text: '${job.applicants} applicants',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor7E7F7E,
                  ),

                  // Salary
                  CustomText(
                    text: job.salary,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}