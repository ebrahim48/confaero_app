import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/sidebar_controller.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SidebarController());

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header with Profile
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff32A69A),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Obx(
                            () => Image.asset(
                          controller.userAvatar.value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 30.sp,
                              color: AppColors.textColor7E7F7E,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                              () => CustomText(
                            text: controller.userName.value,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                        ),
                        SizedBox(height: 4.h),
                      GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.myProfileScreen);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/edit.svg',
              width: 14.w,
              height: 14.h,
              colorFilter: ColorFilter.mode(
                AppColors.textColor7E7F7E,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: 'Edit Profile',
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
            ),
          ],
        ),
      ),

                     ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: controller.menuItems.length,
                itemBuilder: (context, index) {
                  final item = controller.menuItems[index];
                  return _buildMenuItem(context, controller, item);
                },
              ),
            ),

            // Logout Button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () => controller.logout(context),
                leading: SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
                title: CustomText(
                  text: 'Logout',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      SidebarController controller,
      SidebarMenuItem item,
      ) {
    return ListTile(
      onTap: () => controller.handleMenuTap(context, item),
      leading: SvgPicture.asset(
        item.icon,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(
          AppColors.textColor424242,
          BlendMode.srcIn,
        ),
      ),
      title: CustomText(
        textAlign: TextAlign.start,
        text: item.label,
        fontsize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor424242,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: AppColors.textColor7E7F7E,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    );
  }
}