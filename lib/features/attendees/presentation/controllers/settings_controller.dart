import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SettingsController extends GetxController {
  // Notification toggle state
  final RxBool notificationEnabled = true.obs;

  void toggleNotification(bool value) {
    notificationEnabled.value = value;
    // Save to local storage or API
    print('Notification: $value');
  }

  void navigateToRoleSwitch() {
    // Navigate to role switch screen
    Get.toNamed('/role-switch');
  }

  void navigateToChangePassword(BuildContext context) {
   context.pushNamed(AppRoutes.changePasswordScreen);
  }

  void navigateToDeleteAccount(BuildContext context) {
    context.pushNamed(AppRoutes.deleteAccountScreen);
  }

  @override
  void onInit() {
    super.onInit();
    // Load notification preference
  }
}