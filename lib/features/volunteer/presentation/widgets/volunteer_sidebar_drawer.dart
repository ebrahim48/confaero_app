import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../controllers/volunteer_sidebar_controller.dart';

class VolunteerSidebarDrawer extends StatelessWidget {
  const VolunteerSidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerSidebarController());

    final menuItems = [
      _MenuItem('assets/icons/organizer.svg', 'My Profile', AppRoutes.myProfileScreen, Icons.person_outline),
      _MenuItem('assets/icons/notebook.svg', 'Check-in History', AppRoutes.checkHistoryScreen, Icons.history),
      _MenuItem('assets/icons/settings.svg', 'Settings', AppRoutes.settingsScreen, Icons.settings_outlined),
      _MenuItem('assets/icons/about.svg', 'About', AppRoutes.aboutUsScreen, Icons.info_outline),
      _MenuItem('assets/icons/termsconditions.svg', 'Terms & Conditions', AppRoutes.termsConditionScreen, Icons.description_outlined),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                border: Border(
                  bottom: BorderSide(color: const Color(0xffE0E0E0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Obx(() {
                    final url = controller.userAvatar.value;
                    return Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primaryColor32A69A, width: 2),
                      ),
                      child: ClipOval(
                        child: controller.isNetworkAvatar.value
                            ? Image.network(url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(Icons.person,
                                    size: 28.sp,
                                    color: AppColors.textColor7E7F7E))
                            : Image.asset(url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(Icons.person,
                                    size: 28.sp,
                                    color: AppColors.textColor7E7F7E)),
                      ),
                    );
                  }),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => CustomText(
                              text: controller.userName.value.isNotEmpty
                                  ? controller.userName.value
                                  : 'Volunteer',
                              fontsize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor424242,
                            )),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: 'Volunteer',
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

            // Menu Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    onTap: () => controller.handleMenuTap(context, item.route),
                    leading: SvgPicture.asset(
                      item.icon,
                      width: 22.w,
                      height: 22.h,
                      colorFilter: ColorFilter.mode(
                          AppColors.textColor424242, BlendMode.srcIn),
                      placeholderBuilder: (_) => Icon(item.fallbackIcon,
                          size: 22.w, color: AppColors.textColor424242),
                    ),
                    title: CustomText(
                      textAlign: TextAlign.start,
                      text: item.label,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                  );
                },
              ),
            ),

            // Logout
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: const Color(0xffE0E0E0), width: 1),
                ),
              ),
              child: ListTile(
                onTap: () => controller.logout(context),
                leading: SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 22.w,
                  height: 22.h,
                  colorFilter:
                      const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
                title: CustomText(
                  textAlign: TextAlign.start,
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
}

class _MenuItem {
  final String icon;
  final String label;
  final String route;
  final IconData fallbackIcon;

  _MenuItem(this.icon, this.label, this.route, this.fallbackIcon);
}
