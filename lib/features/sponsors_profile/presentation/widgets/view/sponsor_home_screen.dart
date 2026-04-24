import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/sponsor_profile_controller.dart';
import '../sponsor_header_card.dart';
import '../sponsor_state_card.dart';

class SponsorHomeScreen extends StatefulWidget {
  const SponsorHomeScreen({super.key});

  @override
  State<SponsorHomeScreen> createState() => _SponsorHomeScreenState();
}

class _SponsorHomeScreenState extends State<SponsorHomeScreen> {
  late final SponsorProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SponsorProfileController>()
        ? Get.find<SponsorProfileController>()
        : Get.put(SponsorProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return _buildShimmer();

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
                      backgroundImage: const AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Sponsor',
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
                    Icon(Icons.menu, size: 22.sp, color: AppColors.textColor424242),
                  ],
                ),
                SizedBox(height: 20.h),

                // Sponsor header card
                SponsorHeaderCard(
                  hasProfile: controller.hasProfile.value,
                  displayName: controller.companyName.value,
                  description: controller.description.value,
                  status: controller.sponsorStatus.value,
                  logoPath: controller.logoPath.value,
                  pickedFile: controller.pickedImageFile.value,
                  onEditTap: () async {
                    await context.push(AppRoutes.sponsorProfileScreen);
                    controller.loadProfile();
                  },
                ),

                // Stats — only when profile exists
                if (controller.hasProfile.value) ...[
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: SponsorStatCard(
                          icon: Icons.people_outline,
                          value: controller.totalAttendee.value.toString(),
                          label: 'Total Attendees',
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: SponsorStatCard(
                          icon: Icons.remove_red_eye_outlined,
                          value: controller.profileView.value.toString(),
                          label: 'Profile Views',
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 24.h),
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
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120.w, height: 14.h, color: Colors.white),
                    SizedBox(height: 4.h),
                    Container(width: 80.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Header card shimmer
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
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
