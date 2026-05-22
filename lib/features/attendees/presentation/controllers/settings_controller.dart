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
      _logger.e('Failed to toggle notification: $e');
    }
  }

  void navigateToRoleSwitch(BuildContext context) {
    context.pushNamed(AppRoutes.roleSwitchScreen);
  }

  void navigateToChangePassword(BuildContext context) {
    context.pushNamed(AppRoutes.changePasswordScreen);
  }

  void navigateToDeleteAccount(BuildContext context) {
    context.pushNamed(AppRoutes.deleteAccountScreen);
  }

  // changePassword and deleteAccount moved to dedicated controllers
}
