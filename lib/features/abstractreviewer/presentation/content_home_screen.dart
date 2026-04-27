import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/config/approutes/app_routes.dart';
import '../data/reviewer_models.dart';
import 'cotroller/content_controller.dart';
import 'widgets/content_state_card.dart';

class ContentHomeScreen extends StatelessWidget {
  const ContentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContentController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor32A69A,
          onRefresh: controller.loadDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundImage:
                          const AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reviewer Dashboard',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor252525)),
                          Text('Review submitted documents',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textColor7E7F7E)),
                        ],
                      ),
                    ),
                    Obx(() => controller.isLoading.value
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor32A69A),
                          )
                        : GestureDetector(
                            onTap: controller.loadDashboard,
                            child: Icon(Icons.refresh,
                                size: 22.sp,
                                color: AppColors.textColor424242),
                          )),
                  ],
                ),
                SizedBox(height: 20.h),

                // Progress
                Text('Total Progress',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor252525)),
                SizedBox(height: 2.h),
                Text("You're doing great! Keep it up.",
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textColor7E7F7E)),
                SizedBox(height: 10.h),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: LinearProgressIndicator(
                              value: controller.progressPercent.clamp(0.0, 1.0),
                              minHeight: 8.h,
                              backgroundColor: const Color(0xffE0E0E0),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xff32A69A)),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '${(controller.progressPercent * 100).toInt()}%',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor252525),
                        ),
                      ],
                    )),
                SizedBox(height: 6.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${controller.completedTasks} of ${controller.totalTasks} tasks completed',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textColor7E7F7E)),
                        Text('${controller.remainingTasks} remaining',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textColor7E7F7E)),
                      ],
                    )),
                SizedBox(height: 20.h),

                // Stats
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ContentStatCard(
                            icon: Icons.description_outlined,
                            value: controller.totalAbstracts.toString(),
                            label: 'Abstracts',
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: ContentStatCard(
                            icon: Icons.sticky_note_2_outlined,
                            value: controller.totalPosters.toString(),
                            label: 'Posters',
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20.h),

                Text('Latest uploaded document',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525)),
                SizedBox(height: 12.h),

                Obx(() {
                  if (controller.isLoading.value &&
                      controller.latestDocuments.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor32A69A),
                    );
                  }
                  if (controller.latestDocuments.isEmpty) {
                    return Center(
                      child: Text('No documents yet',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textColor7E7F7E)),
                    );
                  }
                  return Column(
                    children: controller.latestDocuments
                        .map((doc) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _LatestDocTile(
                                doc: doc,
                                onTap: () => context
                                    .pushNamed(AppRoutes.abstractsListScreen),
                              ),
                            ))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LatestDocTile extends StatelessWidget {
  final LatestDocumentModel doc;
  final VoidCallback onTap;

  const _LatestDocTile({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPoster = doc.type == 'image';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isPoster
                    ? const Color(0xffFFF8E6)
                    : const Color(0xffEAF4FF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                isPoster
                    ? Icons.sticky_note_2_outlined
                    : Icons.description_outlined,
                size: 20.sp,
                color: isPoster
                    ? const Color(0xffE5A000)
                    : const Color(0xff1A73E8),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor252525),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 2.h),
                  Text(doc.authorName,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor7E7F7E)),
                ],
              ),
            ),
            _statusBadge(doc.reviewStatus),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'approved':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        break;
      case 'rejected':
        bg = const Color(0xffFFEBEB);
        text = Colors.red;
        break;
      case 'assigned':
        bg = const Color(0xffFFF8E6);
        text = const Color(0xffE5A000);
        break;
      default:
        bg = const Color(0xffF0F0F0);
        text = AppColors.textColor7E7F7E;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(status,
          style: TextStyle(
              fontSize: 10.sp, fontWeight: FontWeight.w500, color: text)),
    );
  }
}
