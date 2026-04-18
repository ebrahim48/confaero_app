import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/job_details_controller.dart';
import '../topcard-widget.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;
  const JobDetailsScreen({super.key, this.jobId = ''});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobDetailsController());
    if (jobId.isNotEmpty) controller.loadJobDetails(jobId);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Job Details',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.jobDetails.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // All Job Details Widgets
                      JobDetailsWidgets(controller: controller),

                      SizedBox(height: 24.h),

                      // Apply Button
                      CustomButton(
                        title: 'Apply Now',
                        onpress: () => controller.applyForJob(),
                        color: const Color(0xff32A69A),
                        height: 48.h,
                        borderRadius: 8.r,
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}