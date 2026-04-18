import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/job_details_controller.dart';
import '../topcard-widget.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;
  const JobDetailsScreen({super.key, this.jobId = ''});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late final JobDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(JobDetailsController());
    if (widget.jobId.isNotEmpty) controller.loadJobDetails(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {

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
                  () => controller.isLoading.value || controller.jobDetails.value == null
                  ? _JobDetailShimmer()
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

class _JobDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(height: 163.h, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r))),
            SizedBox(height: 12.h),
            _box(120.w, 16.h),
            SizedBox(height: 8.h),
            _box(double.infinity, 12.h),
            SizedBox(height: 24.h),
            // Description
            _box(100.w, 16.h),
            SizedBox(height: 8.h),
            _box(double.infinity, 12.h),
            SizedBox(height: 6.h),
            _box(double.infinity, 12.h),
            SizedBox(height: 6.h),
            _box(200.w, 12.h),
            SizedBox(height: 24.h),
            // Requirements
            _box(120.w, 16.h),
            SizedBox(height: 8.h),
            _box(double.infinity, 12.h),
            SizedBox(height: 6.h),
            _box(180.w, 12.h),
            SizedBox(height: 24.h),
            // Info
            _box(100.w, 16.h),
            SizedBox(height: 12.h),
            ...List.generate(4, (_) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _box(80.w, 14.h),
                SizedBox(height: 4.h),
                _box(160.w, 12.h),
              ]),
            )),
            SizedBox(height: 8.h),
            // Button
            _box(double.infinity, 48.h, radius: 8),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double radius = 4}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      );
}