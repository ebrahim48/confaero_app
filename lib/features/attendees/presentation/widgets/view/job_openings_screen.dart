import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/job_openings_controller.dart';
import '../filter_chip_widget.dart';
import '../job_cards_widget.dart';


class JobOpeningsScreen extends StatelessWidget {
  const JobOpeningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(JobOpeningsController());

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
                      text: 'Job Openings',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xffFEFEFE),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: const Color(0xffD2D2D2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Search Icon
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 20.w,
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.textColor7E7F7E,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  // Search TextField
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchJobs,
                      decoration: InputDecoration(
                        hintText: 'Search job opening, title, etc',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor424242,
                      ),
                    ),
                  ),

                  // ConfAero Icon (Filter)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/confareo.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: 'ConfAero',
                            fontsize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor424242,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 32.h,
            child:  ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: controller.filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = controller.filterOptions[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: filter,
                      isSelected: controller.selectedFilter.value == filter,
                      onTap: () => controller.selectFilter(filter),
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: 16.h),

          // Job List Label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Job List',
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Job List
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: controller.refreshJobs,
                child: controller.jobs.isEmpty
                    ? Center(
                  child: CustomText(
                    text: 'No jobs available',
                    fontsize: 14.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.jobs.length,
                  itemBuilder: (context, index) {
                    final job = controller.jobs[index];
                    return JobCardWidget(
                      job: job,
                      onTap: () {
                        context.pushNamed(AppRoutes.jobDetailsScreen);
                        // Navigate to job details
                        print('Job tapped: ${job.id}');
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}