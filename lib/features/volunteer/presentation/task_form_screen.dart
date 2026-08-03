import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/config/approutes/app_routes.dart';
import 'controllers/volunteer_tasks_controller.dart';
import 'widgets/task_card.dart';
import 'widgets/task_progress_header.dart';
import 'widgets/task_tab_switch.dart';
import 'widgets/volunteer_sidebar_drawer.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController());
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xffF5F5F5),
      endDrawer: const VolunteerSidebarDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
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
                        Text('My Tasks',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor252525)),
                        Obx(() => Text(
                              '${controller.currentTasks.length} active task(s)',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textColor7E7F7E),
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        context.pushNamed(AppRoutes.notificationsScreen),
                    child: Icon(Icons.notifications_outlined,
                        size: 24.sp, color: AppColors.textColor424242),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                    child: Icon(Icons.menu,
                        size: 24.sp, color: AppColors.textColor424242),
                  ),
                ],
              ),
            ),

            Obx(() => TaskProgressHeader(
                  percent: controller.progressFraction.value,
                  completed: controller.completedTasks.value,
                  total: controller.totalTasks.value,
                  remaining: controller.remainingTasks.value,
                )),

            SizedBox(height: 14.h),

            Obx(() => TaskTabSwitch(
                  selectedTab: controller.selectedTab.value,
                  onSelect: controller.selectTab,
                )),

            SizedBox(height: 14.h),

            Expanded(
              child: Obx(() {
                final tasks = controller.selectedTab.value == 'Current Task'
                    ? controller.currentTasks
                    : controller.historyTasks;

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor32A69A),
                  );
                }

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 48.sp, color: AppColors.textColor7E7F7E),
                        SizedBox(height: 12.h),
                        Text(
                          controller.selectedTab.value == 'Current Task'
                              ? 'No active tasks'
                              : 'No completed tasks',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textColor7E7F7E),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) => TaskCard(
                    task: tasks[i],
                    isHistory:
                        controller.selectedTab.value == 'Task History',
                    onComplete: () =>
                        controller.completeTask(tasks[i].id),
                    onViewDetails: () => context.pushNamed(
                      AppRoutes.taskDetailScreen,
                      extra: tasks[i].id,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
