import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../settings_tile_widgets.dart';
import 'customswith_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'Settings',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Notification Toggle
                  Obx(() => SettingsTileWidget(
                    icon: 'assets/icons/notification.svg',
                    title: 'Notification',
                    trailing: CustomSwitchWidget(
                      value: controller.notificationEnabled.value,
                      onChanged: controller.toggleNotification,
                    ),
                  )),
                  SizedBox(height: 12.h),

                  // Role Switch
                  SettingsTileWidget(
                    icon: 'assets/icons/rolearrow.svg',
                    title: 'Role switch',
                    onTap: () => controller.navigateToRoleSwitch(context),
                  ),
                  SizedBox(height: 12.h),

                  // Change Password
                  SettingsTileWidget(
                    icon: 'assets/icons/lock.svg',
                    title: 'Change Password',
                    onTap: () => controller.navigateToChangePassword(context),
                  ),
                  SizedBox(height: 12.h),

                  // Delete Account
                  SettingsTileWidget(
                    icon: 'assets/icons/delete.svg',
                    title: 'Delete Account',
                    onTap: () => controller.navigateToDeleteAccount(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

