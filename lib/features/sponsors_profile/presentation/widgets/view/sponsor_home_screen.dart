import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/sponsor_profile_controller.dart';
import '../sponsor_header_card.dart';


class SponsorHomeScreen extends StatelessWidget {
  const SponsorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SponsorProfileController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Obx(() => SponsorHeaderCard(
                hasProfile: controller.hasProfile.value,
                displayName: controller.sponsorDisplayName.value,
                description:
                'Lorem Ipsum is simply dummy text of the printing and typesetting ind...',
                status: controller.sponsorStatus.value,
                logoPath: controller.logoPath.value,
                onEditTap: () =>
                    context.pushNamed(AppRoutes.sponsorProfileScreen),
              )),




            ],
          ),
        ),
      ),

    );
  }


}