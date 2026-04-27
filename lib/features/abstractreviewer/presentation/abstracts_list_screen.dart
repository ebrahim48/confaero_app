import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/config/approutes/app_routes.dart';
import '../data/reviewer_models.dart';
import 'cotroller/abstracts_controller.dart';
import 'widgets/submission_list_tile.dart';

class AbstractsListScreen extends StatelessWidget {
  const AbstractsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AbstractsController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text('Abstracts',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor252525)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                    color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
              ),
              child: TextFormField(
                controller: controller.searchController,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textColor424242),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  prefixIcon: Icon(Icons.search,
                      size: 20.sp, color: AppColors.textColor7E7F7E),
                  hintText: 'Search authors by name',
                  hintStyle: TextStyle(
                      fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                ),
              ),
            ),
          ),

          // Submissions header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Authors',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525)),
                Obx(() => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F0F0),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${controller.pendingCount} Pending',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textColor7E7F7E,
                        fontWeight: FontWeight.w500),
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.authors.isEmpty) {
                return _shimmerList();
              }
              final list = controller.filteredAuthors;
              if (list.isEmpty) {
                return Center(
                  child: Text('No authors found',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textColor7E7F7E)),
                );
              }
              return RefreshIndicator(
                color: AppColors.primaryColor32A69A,
                onRefresh: controller.loadAuthors,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => SubmissionListTile(
                    author: list[i],
                    onTap: () => context.pushNamed(
                      AppRoutes.reviewDocumentsScreen,
                      extra: list[i],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _shimmerList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xffE0E0E0),
        highlightColor: const Color(0xffF5F5F5),
        child: Container(
          height: 84.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
