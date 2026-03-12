import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../controllers/sponsor_dashboard_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class SponsorDashboardScreen extends StatelessWidget {
  const SponsorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SponsorDashboardController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff32A69A),
        onPressed: () => context.pushNamed(AppRoutes.sponsorFormScreen),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Sponsor Dashboard'),
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
                    // Stats row
                    Row(
                      children: [
                        _statCard(
                          'Total',
                          '${controller.sponsors.length}',
                          const Color(0xff32A69A),
                        ),
                        SizedBox(width: 12.w),
                        _statCard(
                          'Pending',
                          '${controller.sponsors.where((s) => s['status'] == 'pending').length}',
                          const Color(0xFFFFA000),
                        ),
                        SizedBox(width: 12.w),
                        _statCard(
                          'Approved',
                          '${controller.sponsors.where((s) => s['status'] == 'approved').length}',
                          const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Sponsor list
                    ...controller.sponsors.map((sponsor) {
                      final status = sponsor['status'] as String? ?? 'pending';
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
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xff32A69A),
                                  radius: 20.r,
                                  child: Text(
                                    (sponsor['name'] as String? ?? 'S')[0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sponsor['name'] as String? ?? '',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        sponsor['tier'] as String? ?? 'General',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _statusChip(status),
                              ],
                            ),
                            if (status == 'pending') ...[
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed:
                                          () => controller.rejectSponsor(
                                            sponsor['_id'] as String? ?? '',
                                          ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          () => controller.approveSponsor(
                                            sponsor['_id'] as String? ?? '',
                                          ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xff32A69A,
                                        ),
                                      ),
                                      child: const Text(
                                        'Approve',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String count, Color color) {
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

  Widget _statusChip(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'approved':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF4CAF50);
        break;
      case 'rejected':
        bg = const Color(0xFFFFEBEE);
        fg = Colors.red;
        break;
      default:
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFFFA000);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.capitalize!,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
