import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../auth/data/repositories/auth_repository.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class RoleSwitchController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final _roleController = Get.find<RoleController>();
  final _logger = LoggerHelper('RoleSwitchController');

  /// All roles the user has been assigned
  final RxList<String> availableRoles = <String>[].obs;

  /// The user's currently active role (delegated to RoleController)
  String get activeRole => _roleController.activeRole.value;

  /// Loading states
  final RxBool isLoadingRoles = false.obs;
  final RxBool isSwitching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRoles();
  }

  /// Fetch all roles assigned to the current user
  Future<void> fetchMyRoles() async {
    isLoadingRoles.value = true;
    try {
      final response = await _authRepository.getMyRoles();
      final success = response['success'] as bool? ?? false;

      if (success && response['data'] != null) {
        final data = response['data'];
        if (data is List) {
          availableRoles.assignAll(data.cast<String>());
          _roleController.setUserRoles(data.cast<String>());
        } else if (data is Map<String, dynamic>) {
          // Handle case where data contains roles list
          final roles = data['roles'] as List?;
          if (roles != null) {
            availableRoles.assignAll(roles.cast<String>());
            _roleController.setUserRoles(roles.cast<String>());
          }
          // Also read activeRole from server if available
          final serverActiveRole = data['activeRole'] as String?;
          if (serverActiveRole != null && serverActiveRole.isNotEmpty) {
            await _roleController.setRole(serverActiveRole);
          }
        }
      }

      _logger.d('Available roles: $availableRoles, Active: ${activeRole}');
    } catch (e) {
      _logger.e('Failed to fetch roles: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to load roles',
        title: 'Error',
      );
    } finally {
      isLoadingRoles.value = false;
    }
  }

  /// Switch to a different role
  Future<void> switchRole(String role, BuildContext context) async {
    if (role.toUpperCase() == activeRole.toUpperCase()) return; // Already active

    isSwitching.value = true;
    try {
      final response = await _authRepository.changeRole(role);
      final success = response['success'] as bool? ?? false;

      if (success) {
        // Update role in RoleController (this will trigger UI rebuild)
        await _roleController.setRole(role);

        // Update token if the server returns a new one
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          final newToken = data['accessToken'] as String?;
          final newRefresh = data['refreshToken'] as String?;
          if (newToken != null) {
            await PrefsHelper.setString(AppConstants.bearerToken, newToken);
          }
          if (newRefresh != null) {
            await PrefsHelper.setString(AppConstants.refreshToken, newRefresh);
          }
        }

        ToastMessageHelper.showToastMessage(
          'Switched to ${formatRoleName(role)}',
          title: 'Success',
        );

        // Navigate to main screen so the new role takes effect
        // The MainNavigationScreen will rebuild with the new role UI
        if (context.mounted) {
          context.go(AppRoutes.mainNavigationScreen);
        }
      } else {
        final message = response['message'] as String? ?? 'Failed to switch role';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to switch role: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to switch role',
        title: 'Error',
      );
    } finally {
      isSwitching.value = false;
    }
  }

  /// Get a human-friendly role name
  static String formatRoleName(String role) => RoleController.formatRoleName(role);

  /// Get an icon for each role
  static IconData getRoleIcon(String role) => RoleController.getRoleIcon(role);
}
