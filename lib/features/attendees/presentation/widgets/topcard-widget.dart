import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/job_details_controller.dart';

class JobDetailsWidgets extends StatelessWidget {
  final JobDetailsController controller;

  const JobDetailsWidgets({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final job = controller.jobDetails.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Card with Image
        _buildTopCard(job),

        SizedBox(height: 16.h),

        // Job Description
        _buildJobDescription(job),

        SizedBox(height: 16.h),

        // Requirements
        _buildRequirements(job),

        SizedBox(height: 16.h),

        // Location
        _buildLocation(job),

        SizedBox(height: 16.h),

        // Informations
        _buildInformations(job),

        SizedBox(height: 16.h),

        // Facilities and Others
        _buildFacilities(job),
      ],
    );
  }

  // Top Card Widget
  Widget _buildTopCard(job) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
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
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 12.h, right: 5.w, top: 9.h, left: 12.w),
            child: CustomText(
              text: job.companyName,
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor424242,
            ),
          ),

          // Bottom Info
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, right: 12.w, top: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    CustomText(
                      text: job.position,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor252525,
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.work_outline,
                      size: 14.sp,
                      color: AppColors.textColor252525,
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: job.jobType,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor252525,
                    ),
                    const Spacer(),
                    CustomText(
                      text: job.salary,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor252525,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Location & Last Date
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: AppColors.textColor252525,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: job.location,
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor252525,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Last Date : ${job.lastDate}',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor252525,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Job Description Section
  Widget _buildJobDescription(job) {
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
          textAlign: TextAlign.start,
          text: job.description,
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
          maxline: 12,
        ),
      ],
    );
  }

  // Requirements Section
  Widget _buildRequirements(job) {
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
                    textAlign: TextAlign.start,
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

  // Location Section
  Widget _buildLocation(job) {
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

  // Informations Section
  Widget _buildInformations(job) {
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

  // Info Row Helper
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

  // Facilities Section
  Widget _buildFacilities(job) {
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