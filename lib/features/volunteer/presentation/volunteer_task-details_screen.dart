import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/config/approutes/app_routes.dart';
import '../../../presentations/widgets/custom_button.dart';
import 'controllers/volunteer_task_detail_controller.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TaskDetailController(),
      tag: taskId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.taskDetail.value == null) {
        controller.loadDetail(taskId);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text('Task Detail',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor252525)),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppColors.primaryColor32A69A),
          );
        }

        final task = controller.taskDetail.value;
        if (task == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48.sp, color: AppColors.textColor7E7F7E),
                SizedBox(height: 12.h),
                Text('Failed to load task detail',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textColor7E7F7E)),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => controller.loadDetail(taskId),
                  child: Text('Retry',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor32A69A,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              Text(
                task.title,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor252525,
                    height: 1.3),
              ),
              SizedBox(height: 8.h),

              _statusBadge(task.status),
              SizedBox(height: 20.h),

              _infoCard(
                icon: Icons.calendar_today_outlined,
                title: _formatDate(task.startDate),
                subtitle: _formatTimeRange(task.startDate, task.endDate),
              ),
              SizedBox(height: 10.h),
              _infoCard(
                icon: Icons.location_on_outlined,
                title: task.location,
                subtitle: '',
              ),
              SizedBox(height: 20.h),

              Text('Instruction',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor252525)),
              SizedBox(height: 10.h),

              Obx(() {
                final full = controller.showFullInstruction.value;
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        color:
                            AppColors.borderColorD2D2D2.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.instruction,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textColor424242,
                            height: 1.6),
                        maxLines: full ? null : 5,
                        overflow:
                            full ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                      if (task.instruction.length > 200) ...[
                        SizedBox(height: 4.h),
                        GestureDetector(
                          onTap: controller.toggleInstruction,
                          child: Text(
                              full ? 'Read Less' : 'Read More',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor32A69A,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              SizedBox(height: 20.h),

              Text('Organizer',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor252525)),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.borderColorD2D2D2,
                      backgroundImage:
                          task.createdBy.photo.startsWith('http')
                              ? NetworkImage(task.createdBy.photo)
                                  as ImageProvider
                              : const AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              task.createdBy.name.isNotEmpty
                                  ? task.createdBy.name
                                  : task.createdBy.email,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor252525)),
                          Text(task.createdBy.role.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textColor7E7F7E,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final task = controller.taskDetail.value;
        const activeStatuses = {'PENDING', 'IN_PROGRESS', 'DUE'};
        final isActive = activeStatuses.contains(task?.status);
        if (!isActive && task != null) return const SizedBox.shrink();
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          color: AppColors.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => CustomButton(
                    title: 'Complete Task',
                    loading: controller.isCompleting.value,
                    onpress: () => controller.completeTask(context),
                  )),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => context.pushNamed(
                  AppRoutes.reportIssueScreen,
                  extra: taskId,
                ),
                child: Text(
                  'Report an Issue',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryColor32A69A,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    String label;
    switch (status) {
      case 'PENDING':
        bg = const Color(0xffEAF4FF);
        text = const Color(0xff1A73E8);
        label = 'Pending';
        break;
      case 'IN_PROGRESS':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        label = 'In Progress';
        break;
      case 'DUE':
        bg = const Color(0xffFFEBEB);
        text = const Color(0xffD32F2F);
        label = 'Due';
        break;
      case 'COMPLETED':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        label = 'Completed';
        break;
      case 'REPORTED':
        bg = const Color(0xffFFF8E6);
        text = const Color(0xffE5A000);
        label = 'Reported';
        break;
      default:
        bg = const Color(0xffF0F0F0);
        text = AppColors.textColor7E7F7E;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.w500, color: text)),
    );
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatTimeRange(String start, String end) {
    if (start.isEmpty) return '';
    try {
      final s = DateTime.parse(start);
      String result = _toAmPm(s);
      if (end.isNotEmpty) {
        final e = DateTime.parse(end);
        result += ' - ${_toAmPm(e)}';
      }
      return result;
    } catch (_) {
      return '';
    }
  }

  String _toAmPm(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:
            Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child:
                Icon(icon, size: 20.sp, color: AppColors.textColor424242),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor252525)),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textColor7E7F7E)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
