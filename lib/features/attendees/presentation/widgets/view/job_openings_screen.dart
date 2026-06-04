import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../job/presentation/widgets/post_a_job_screen.dart';
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
      floatingActionButton: Obx(() {
        final role = RoleController.to.activeRole.value;
        if (role == 'SPONSOR' || role == 'EXHIBITOR') {
          return _BuildAddFab();
        }
        return const SizedBox.shrink();
      }),
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
                  ? const _JobListShimmer()
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
                        context.pushNamed(
                          AppRoutes.jobDetailsScreen,
                          extra: job.id,
                        );
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

class _BuildAddFab extends StatelessWidget {
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

class _JobListShimmer extends StatelessWidget {
  const _JobListShimmer();

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