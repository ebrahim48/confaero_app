import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/role_controller.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import 'controllers/role_switch_controller.dart';

class RoleSwitchScreen extends StatelessWidget {
  const RoleSwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleSwitchController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Switch Role'),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: CustomText(
              text: 'Select a role to switch your active view. Your available roles depend on your event registrations.',
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              textAlign: TextAlign.center,
              maxline: 3,
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoadingRoles.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Empty state
              if (controller.availableRoles.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_horiz_rounded,
                          size: 64.w,
                          color: AppColors.iconColorAEAEAE,
                        ),
                        SizedBox(height: 16.h),
                        CustomText(
                          text: 'No roles available',
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor252525,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: 'You currently have only one role assigned.',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                          textAlign: TextAlign.center,
                          maxline: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Roles list
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                itemCount: controller.availableRoles.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final role = controller.availableRoles[index];
                  final isActive = role.toUpperCase() ==
                      controller.activeRole.toUpperCase();

                  return _RoleCard(
                    role: role,
                    isActive: isActive,
                    isSwitching: controller.isSwitching.value,
                    onTap: isActive
                        ? null
                        : () => controller.switchRole(role, context),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String role;
  final bool isActive;
  final bool isSwitching;
  final VoidCallback? onTap;

  const _RoleCard({
    required this.role,
    required this.isActive,
    required this.isSwitching,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSwitching ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryColor32A69A.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor32A69A
                : AppColors.borderColorD2D2D2,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Role icon
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor32A69A.withValues(alpha: 0.15)
                    : AppColors.textColorF6F6F6,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                RoleController.getRoleIcon(role),
                color: isActive
                    ? AppColors.primaryColor32A69A
                    : AppColors.textColor707070,
                size: 24.w,
              ),
            ),

            SizedBox(width: 16.w),

            // Role name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: RoleController.formatRoleName(role),
                    fontsize: 16.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? AppColors.primaryColor32A69A
                        : AppColors.textColor252525,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: isActive ? 'Currently active' : 'Tap to switch',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isActive
                        ? AppColors.primaryColor32A69A
                        : AppColors.textColor7E7F7E,
                  ),
                ],
              ),
            ),

            // Trailing indicator
            if (isActive)
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor32A69A,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16.w,
                ),
              )
            else if (isSwitching)
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor32A69A,
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: AppColors.iconColorAEAEAE,
                size: 24.w,
              ),
          ],
        ),
      ),
    );
  }
}
