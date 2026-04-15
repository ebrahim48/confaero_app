import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/volunteer_tasks_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

/// Volunteer Tasks Screen - Shows Today's Progress and Task List
class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerTasksController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with menu button
          CustomAppBarWidget(
            title: 'Volunteer Dashboard',
            showMenuButton: true,
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: controller.loadTasks,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // Today's Progress Card
                    _buildProgressCard(controller),

                    SizedBox(height: 16.h),

                    // Tab Switcher
                    _buildTabSwitcher(controller),

                    SizedBox(height: 16.h),

                    // Task List
                    if (controller.tasks.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task,
                              size: 64.r,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No tasks yet',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...controller.tasks.map(
                        (task) => _TaskCard(
                          task: task,
                          showHistory: controller.showHistory.value,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(VolunteerTasksController controller) {
    final completed = controller.completedCount.value;
    final total = controller.totalCount.value;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Progress",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "You're doing great! Keep it up.",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF32A69A),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF32A69A)),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed of $total tasks completed',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${total - completed} remaining',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher(VolunteerTasksController controller) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.showHistory.value = false,
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  color: !controller.showHistory.value
                      ? const Color(0xFF32A69A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Current Task',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: !controller.showHistory.value
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.showHistory.value = true,
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  color: controller.showHistory.value
                      ? const Color(0xFF32A69A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Task History',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: controller.showHistory.value
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool showHistory;

  const _TaskCard({required this.task, required this.showHistory});

  @override
  Widget build(BuildContext context) {
    final status = task['status']?.toString().toLowerCase() ?? 'pending';
    final isInProgress = status == 'in_progress' || status == 'in progress';
    final isCompleted = status == 'completed';
    final isPending = status == 'pending' || status == 'due';

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to task detail screen when route is available
        // context.pushNamed(AppRoutes.taskDetailScreen, extra: task);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isInProgress
                ? const Color(0xFF32A69A)
                : Colors.grey.shade200,
            width: isInProgress ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D000000),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Left border indicator
            if (isInProgress)
              Container(
                width: 4.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF32A69A),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            if (isInProgress) SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  _buildStatusBadge(status),
                  SizedBox(height: 6.h),
                  // Task name
                  Text(
                    task['name'] as String? ?? 'Task',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        task['time'] ?? '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        task['location'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Action button
                  if (!showHistory) _buildActionButton(status),
                ],
              ),
            ),
            // Thumbnail
            if (task['image'] != null && task['image'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  task['image'],
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderImage(),
                ),
              )
            else
              _placeholderImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'completed':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        label = 'Completed';
        break;
      case 'in_progress':
      case 'in progress':
        bgColor = const Color(0xFF32A69A).withOpacity(0.1);
        textColor = const Color(0xFF32A69A);
        label = 'In Progress';
        break;
      case 'due':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        label = 'Due';
        break;
      default:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        label = 'Pending';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButton(String status) {
    if (status.toLowerCase() == 'completed') {
      return const SizedBox.shrink();
    }

    final isInProgress =
        status.toLowerCase() == 'in_progress' ||
        status.toLowerCase() == 'in progress';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isInProgress ? Colors.grey.shade400 : const Color(0xFF32A69A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isInProgress ? 'Complete' : 'View Details',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.image, size: 24.sp, color: Colors.grey.shade400),
    );
  }
}
