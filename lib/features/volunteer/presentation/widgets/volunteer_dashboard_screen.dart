import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../controllers/volunteer_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff32A69A),
        onPressed: () => context.pushNamed(AppRoutes.taskFormScreen),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Volunteer Dashboard'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task, size: 64.r, color: Colors.grey.shade300),
                      SizedBox(height: 16.h),
                      Text(
                        'No tasks yet',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadDashboard,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFD7EAE8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0D000000),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['name'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            task['description'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF7E7F7E),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14.r,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                task['location'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
