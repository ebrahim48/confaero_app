import 'package:confaero_app/core/helpers/logger_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class SettingsController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final _logger = LoggerHelper('SettingsController');
  // Notification toggle state
  final RxBool notificationEnabled = true.obs;

  final RxBool isLoading = false.obs;

  void toggleNotification(bool value) async {
    try {
      notificationEnabled.value = value;
      await _authRepository.toggleNotification(value);
      _logger.d('Notification updated: $value');
    } catch (e) {
      notificationEnabled.value = !value; // Revert on failure
      Get.snackbar('Error', 'Failed to update notification settings');
      _logger.e('Failed to toggle notification: $e');
    }
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

  // changePassword and deleteAccount moved to dedicated controllers

  @override
  void onInit() {
    super.onInit();
    // Load notification preference
  }
}
