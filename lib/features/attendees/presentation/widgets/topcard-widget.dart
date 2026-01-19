import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/job_details_controller.dart';

// Top Card Widget
class TopCardWidget extends StatelessWidget {
  final JobDetailsController controller;

  const TopCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Container(
      height: 163.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Background Image
            Container(
              height: 163.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(4.r),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/jobopenings.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(4.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.2),
                    ],
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 12,right: 12,top: 9,left: 12),
                child: CustomText(
                  text: job.companyName,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor424242,
                ),
              ),
            ),
        
            // Bottom Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Position & Job Type & Salary
                  Row(
                    children: [
                      CustomText(
                        text: job.position,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor424242,
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.work_outline,
                        size: 14.sp,
                        color: AppColors.textColor424242,
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: job.jobType,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor424242,
                      ),
                      const Spacer(),
                      CustomText(
                        text: job.salary,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor424242,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
        
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
                          text: job.location,
                          fontsize: 11.sp,
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
          ],
        ),
      ),
    );
  }
}

// Job Description Widget
class JobDescriptionWidget extends StatelessWidget {
  final JobDetailsController controller;

  const JobDescriptionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Job Description',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: job.description,
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
        ),
      ],
    );
  }
}

// Requirements Widget
class RequirementsWidget extends StatelessWidget {
  final JobDetailsController controller;

  const RequirementsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Requirements',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 8.h),
        ...job.requirements.map(
              (req) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h, right: 8.w),
                  width: 5.w,
                  height: 5.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: CustomText(
                    text: req,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Location Widget
class LocationWidget extends StatelessWidget {
  final JobDetailsController controller;

  const LocationWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Location',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: job.locationAddress,
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
        ),
        SizedBox(height: 12.h),

        // Map Image
        Container(
          height: 151.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              image: AssetImage(job.mapImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.location_on,
              size: 40.sp,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

// Informations Widget
class InformationsWidget extends StatelessWidget {
  final JobDetailsController controller;

  const InformationsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Informations',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 12.h),
        _buildInfoRow('Position', job.positionInfo),
        _buildInfoRow('Qualification', job.qualification),
        _buildInfoRow('Experience', job.experience),
        _buildInfoRow('Job Type', job.jobTypeInfo),
        _buildInfoRow('Specialization', job.specialization),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor424242,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
          ),
        ],
      ),
    );
  }
}

// Facilities Widget
class FacilitiesWidget extends StatelessWidget {
  final JobDetailsController controller;

  const FacilitiesWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Facilities and Others',
          fontsize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 8.h),
        ...job.facilities.map(
              (facility) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h, right: 8.w),
                  width: 5.w,
                  height: 5.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                CustomText(
                  text: facility,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}