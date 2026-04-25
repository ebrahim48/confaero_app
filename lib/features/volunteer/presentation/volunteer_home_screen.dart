import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/session_controller.dart';
import 'controllers/volunteer_tasks_controller.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage:
                        const AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, Volunteer!',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor252525)),
                        Obx(() => Text(
                              SessionController.to.eventTitle.value.isNotEmpty
                                  ? SessionController.to.eventTitle.value
                                  : 'Event in progress',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textColor7E7F7E),
                            )),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Progress card
              Obx(() => _summaryCard(
                    totalTasks: taskController.totalTasks.value,
                    completedTasks: taskController.completedTasks.value,
                    remainingTasks: taskController.remainingTasks.value,
                    progress: taskController.progressFraction.value,
                  )),

              SizedBox(height: 20.h),

              Text("Today's Assignments",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor252525)),
              SizedBox(height: 12.h),

              Obx(() {
                if (taskController.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor32A69A));
                }
                final tasks = taskController.currentTasks;
                if (tasks.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text('No active tasks for today',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textColor7E7F7E)),
                    ),
                  );
                }
                return Column(
                  children: tasks
                      .take(3)
                      .map((task) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _taskRow(
                              title: task.title,
                              time: _formatTimeRange(task.startDate, task.endDate),
                              location: task.location,
                              status: task.status,
                            ),
                          ))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required int totalTasks,
    required int completedTasks,
    required int remainingTasks,
    required double progress,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff32A69A), Color(0xff28867D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Progress",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('$completedTasks', 'Completed'),
              _statItem('$remainingTasks', 'Remaining'),
              _statItem('$totalTasks', 'Total'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: TextStyle(
                fontSize: 11.sp, color: Colors.white.withOpacity(0.8))),
      ],
    );
  }

  String _formatTimeRange(String start, String end) {
    if (start.isEmpty) return '';
    try {
      final s = DateTime.parse(start);
      final h = s.hour > 12 ? s.hour - 12 : s.hour == 0 ? 12 : s.hour;
      final m = s.minute.toString().padLeft(2, '0');
      final p = s.hour >= 12 ? 'PM' : 'AM';
      String result = '$h:$m $p';
      if (end.isNotEmpty) {
        final e = DateTime.parse(end);
        final eh = e.hour > 12 ? e.hour - 12 : e.hour == 0 ? 12 : e.hour;
        final em = e.minute.toString().padLeft(2, '0');
        final ep = e.hour >= 12 ? 'PM' : 'AM';
        result += ' - $eh:$em $ep';
      }
      return result;
    } catch (_) {
      return start;
    }
  }

  Widget _taskRow({
    required String title,
    required String time,
    required String location,
    required String status,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
                color: AppColors.primaryColor32A69A,
                shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 2.h),
                Text('$time • $location',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textColor7E7F7E),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
