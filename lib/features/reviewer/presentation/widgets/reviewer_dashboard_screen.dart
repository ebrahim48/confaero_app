import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/reviewer_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class ReviewerDashboardScreen extends StatelessWidget {
  const ReviewerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewerController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Reviewer Dashboard'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.loadDashboard,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // Stats
                    if (controller.dashboardData.value != null) ...[
                      Row(
                        children: [
                          _stat(
                            'Pending',
                            '${controller.dashboardData.value?['pendingCount'] ?? 0}',
                            Colors.orange,
                          ),
                          SizedBox(width: 12.w),
                          _stat(
                            'Approved',
                            '${controller.dashboardData.value?['approvedCount'] ?? 0}',
                            const Color(0xFF4CAF50),
                          ),
                          SizedBox(width: 12.w),
                          _stat(
                            'Rejected',
                            '${controller.dashboardData.value?['rejectedCount'] ?? 0}',
                            Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],

                    // Authors
                    Text(
                      'Authors',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...controller.authors.map(
                      (author) => Container(
                        margin: EdgeInsets.only(bottom: 10.h),
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
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xff32A69A),
                            child: Text(
                              (author['name'] as String? ?? 'A')[0]
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(author['name'] as String? ?? ''),
                          subtitle: Text(author['email'] as String? ?? ''),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Color(0xff32A69A),
                          ),
                          onTap: () {
                            controller.loadSubmissions(
                              author['_id'] as String? ?? '',
                            );
                            // Navigate to submissions view
                          },
                        ),
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

  Widget _stat(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(fontSize: 12.sp, color: color)),
          ],
        ),
      ),
    );
  }
}
