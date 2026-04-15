import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/job_service.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import 'job_posting_form_screen.dart';

/// My Jobs Screen for Exhibitors/Sponsors
///
/// Shows list of jobs posted by the current user
class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyJobsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Custom App Bar with Action
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
                      textAlign: TextAlign.start,
                      text: 'My Job Posts',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => Get.to(() => const JobPostingFormScreen()),
                    color: AppColors.primaryColor32A69A,
                    iconSize: 28.sp,
                  ),
                ],
              ),
            ),
          ),

          // Job List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.jobs.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.jobs.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final job = controller.jobs[index];
                  return _buildJobCard(controller, job);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.work_outline,
              size: 80.w,
              color: AppColors.iconColorAEAEAE,
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'No Jobs Posted Yet',
              fontsize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Start posting jobs to attract potential candidates!',
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              textAlign: TextAlign.center,
              maxline: 3,
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () => Get.to(() => const JobPostingFormScreen()),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor32A69A,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Post Your First Job',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(MyJobsController controller, Map<String, dynamic> job) {
    final jobId = job['_id'] as String? ?? '';
    final title = job['title'] as String? ?? 'Job Title';
    final company = job['company'] as String? ?? 'Company';
    final location = job['location'] as String? ?? 'Location';
    final jobType = job['jobType'] as String? ?? 'Full-time';
    final status = job['status'] as String? ?? 'pending';
    final expireDate = job['expireDate'] != null
        ? DateTime.tryParse(job['expireDate'])
        : null;

    final statusColor = _getStatusColor(status);
    final statusLabel = _getStatusLabel(status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor252525,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: company,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: statusLabel,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Details
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.w,
                color: AppColors.textColor7E7F7E,
              ),
              SizedBox(width: 4.w),
              CustomText(
                text: location,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor7E7F7E,
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.work_outline,
                size: 16.w,
                color: AppColors.textColor7E7F7E,
              ),
              SizedBox(width: 4.w),
              CustomText(
                text: jobType,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor7E7F7E,
              ),
            ],
          ),

          if (expireDate != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.w,
                  color: AppColors.textColor7E7F7E,
                ),
                SizedBox(width: 4.w),
                CustomText(
                  text: 'Expires: ${_formatDate(expireDate)}',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                ),
              ],
            ),
          ],

          SizedBox(height: 16.h),

          // Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.jobDetailsScreen, arguments: {'job': job}),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor32A69A.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 18.w,
                          color: AppColors.primaryColor32A69A,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'View',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor32A69A,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.deleteJob(jobId),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18.w,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'Delete',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'pending':
        return 'Pending';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Controller for My Jobs Screen
class MyJobsController extends GetxController {
  final JobService _jobService = Get.find<JobService>();
  final _logger = LoggerHelper('MyJobsController');

  final jobs = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyJobs();
  }

  /// Load my posted jobs
  Future<void> loadMyJobs() async {
    isLoading.value = true;
    try {
      final response = await _jobService.getMyJobPosts();

      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          final jobsList = data['jobs'] as List? ?? [];
          jobs.assignAll(jobsList.map((e) => e as Map<String, dynamic>).toList());
        }
      }
    } catch (e) {
      _logger.e('Failed to load jobs: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to load jobs',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a job
  Future<void> deleteJob(String jobId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Job?'),
        content: const Text('Are you sure you want to delete this job posting?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _jobService.deleteJob(jobId);

      ToastMessageHelper.showToastMessage(
        'Job deleted successfully',
        title: 'Success',
      );
      await loadMyJobs();
    } catch (e) {
      _logger.e('Failed to delete job: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to delete job',
        title: 'Error',
      );
    }
  }
}
