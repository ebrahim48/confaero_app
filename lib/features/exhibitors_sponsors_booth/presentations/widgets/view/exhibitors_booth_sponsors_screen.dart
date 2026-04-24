import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_controllers.dart';
import '../booth_header_card.dart';
import '../booth_quick_action_tile.dart';
import '../booth_state_card.dart';

class BoothScreen extends StatefulWidget {
  const BoothScreen({super.key});

  @override
  State<BoothScreen> createState() => _BoothScreenState();
}

class _BoothScreenState extends State<BoothScreen> {
  late final BoothController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<BoothController>()) {
      controller = Get.put(BoothController());
    } else {
      controller = Get.find<BoothController>();
      // Refresh if we have eventId but booth hasn't loaded yet
      if (controller.eventId.isNotEmpty && !controller.hasBooth.value && !controller.isLoading.value) {
        controller.loadAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmer();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
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
                          Text(
                            'My Booth',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor252525,
                            ),
                          ),
                          Text(
                            _formattedDate(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.notifications_outlined,
                        size: 22.sp, color: AppColors.textColor424242),
                    SizedBox(width: 14.w),
                    Icon(Icons.menu,
                        size: 22.sp, color: AppColors.textColor424242),
                  ],
                ),
                SizedBox(height: 20.h),

                // Booth Header Card
                Obx(() => BoothHeaderCard(
                      hasBooth: controller.hasBooth.value,
                      boothName: controller.boothName,
                      boothLocation: controller.boothNumber.isNotEmpty
                          ? 'Booth #${controller.boothNumber}'
                          : 'Main Exhibition Hall',
                      boothStatus: controller.boothStatus,
                      onCreateTap: () =>
                          context.push(AppRoutes.boothProfileScreen),
                      onEditTap: () =>
                          context.push(AppRoutes.boothProfileScreen),
                    )),

                SizedBox(height: 14.h),

                // Stats Row
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: BoothStatCard(
                            icon: 'assets/icons/totalleads.svg',
                            count: controller.totalLeads.value,
                            label: 'Total Leads',
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: BoothStatCard(
                            icon: 'assets/icons/totalleads.svg',
                            count: controller.totalStaff.value,
                            label: 'Total Staff',
                          ),
                        ),
                      ],
                    )),

                SizedBox(height: 20.h),

                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor252525,
                  ),
                ),
                SizedBox(height: 12.h),

                // Quick Actions
                Obx(() => BoothQuickActionTile(
                      icon: 'assets/icons/totalleads.svg',
                      title: 'Booth Staff',
                      subtitle:
                          'Total member ${controller.totalStaff.value}',
                      backgroundColor: const Color(0xffE8F8F5),
                      iconBgColor: const Color(0xffD0F0EC),
                      onTap: () =>
                          context.push(AppRoutes.boothStaffScreen),
                    )),
                SizedBox(height: 10.h),
                BoothQuickActionTile(
                  icon: 'assets/icons/detailedanalytics.svg',
                  title: 'Detailed Analytics',
                  subtitle: 'Track booth performance',
                  backgroundColor: const Color(0xffE8F8F5),
                  iconBgColor: AppColors.primaryColor32A69A,
                  iconColor: Colors.white,
                  onTap: () =>
                      context.push(AppRoutes.performanceScreen),
                ),
                SizedBox(height: 10.h),
                BoothQuickActionTile(
                  icon: 'assets/icons/scanviewleads.svg',
                  title: 'Scan & View Leads',
                  subtitle: 'Manage your scanned badges',
                  backgroundColor: Colors.white,
                  iconBgColor: const Color(0xffF5F5F5),
                  onTap: () =>
                      context.push(AppRoutes.performanceScreen),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $period,  ${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 120.w, height: 14.h, color: Colors.white),
                    SizedBox(height: 4.h),
                    Container(
                        width: 80.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Card shimmer
            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 14.h),
            // Stats shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 72.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Container(
                    height: 72.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(width: 100.w, height: 16.h, color: Colors.white),
            SizedBox(height: 12.h),
            ...List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  width: double.infinity,
                  height: 58.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
