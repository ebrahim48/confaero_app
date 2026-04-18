import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final job = controller.jobDetails.value;
    if (job == null) return const SizedBox.shrink();

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
              image: DecorationImage(
                image: job.mapImage.startsWith('http')
                    ? NetworkImage(job.mapImage) as ImageProvider
                    : const AssetImage('assets/images/jobopenings.jpg'),
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
                    Flexible(
                      child: CustomText(
                        text: job.position,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525,
                        textAlign: TextAlign.start,
                        maxline: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.work_outline, size: 13.sp, color: AppColors.textColor252525),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: CustomText(
                        text: job.jobType,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor252525,
                        maxline: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: CustomText(
                        text: job.salary,
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor252525,
                        textAlign: TextAlign.end,
                        maxline: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Location & Last Date
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textColor252525),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: job.location,
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor252525,
                        maxline: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Deadline: ${_formatDate(job.lastDate)}',
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
        if (job.locationUrl.isNotEmpty) ...[
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () async {
              final uri = Uri.tryParse(job.locationUrl);
              if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xffF0FAF9),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xff32A69A).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.map_outlined, size: 20.sp, color: const Color(0xff32A69A)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: 'View on Map',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff32A69A),
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 16.sp, color: const Color(0xff32A69A)),
                ],
              ),
            ),
          ),
        ],
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

String _formatDate(String raw) {
  if (raw.isEmpty) return '—';
  try {
    final dt = DateTime.parse(raw).toLocal();
    return DateFormat('MMM d, yyyy').format(dt);
  } catch (_) {
    return raw;
  }
}