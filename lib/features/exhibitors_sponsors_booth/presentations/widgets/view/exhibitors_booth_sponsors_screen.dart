import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_controllers.dart';
import '../booth_header_card.dart';
import '../booth_quick_action_tile.dart';
import '../booth_state_card.dart';


class BoothScreen extends StatelessWidget {
  const BoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BoothController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                          'Hello Albert!',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor252525,
                          ),
                        ),
                        Text(
                          '4:50 pm,  December 15, 2025',
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
                boothName: controller.boothName.value,
                boothLocation: controller.boothLocation.value,
                boothStatus: controller.boothStatus.value,
                onCreateTap: () =>
                    context.pushNamed(AppRoutes.boothProfileScreen),
                onEditTap: () =>
                    context.pushNamed(AppRoutes.boothProfileScreen),
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
              BoothQuickActionTile(
                icon: 'assets/icons/totalleads.svg',
                title: 'Booth Staff',
                subtitle: 'Total member 3',
                backgroundColor: const Color(0xffE8F8F5),
                iconBgColor: const Color(0xffD0F0EC),
                onTap: () => context.pushNamed(AppRoutes.performanceScreen),
              ),
              SizedBox(height: 10.h),
              BoothQuickActionTile(
                icon: 'assets/icons/detailedanalytics.svg',
                title: 'Detailed Analytics',
                subtitle: 'Track booth performance',
                backgroundColor: const Color(0xffE8F8F5),
                iconBgColor: AppColors.primaryColor32A69A,
                iconColor: Colors.white,
                onTap: () => context.pushNamed(AppRoutes.performanceScreen),
              ),
              SizedBox(height: 10.h),
              BoothQuickActionTile(
                icon: 'assets/icons/scanviewleads.svg',
                title: 'Scan & View Leads',
                subtitle: 'Manage your scanned badges',
                backgroundColor: Colors.white,
                iconBgColor: const Color(0xffF5F5F5),
                onTap: () => context.pushNamed(AppRoutes.performanceScreen),
              ),
            ],
          ),
        ),
      ),

    );
  }


}