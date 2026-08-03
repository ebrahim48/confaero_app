import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../auth/data/repositories/auth_repository.dart';

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
          _applyRoles(data);
        } else if (data is Map<String, dynamic>) {
          // GET /auth/my-roles returns { role: [...], activeRole: "..." }.
          // `roles` is tolerated for older backend builds.
          final roles = (data['role'] ?? data['roles']) as List?;
          if (roles != null) _applyRoles(roles);

          // Also read activeRole from server if available
          final serverActiveRole = data['activeRole'] as String?;
          if (serverActiveRole != null && serverActiveRole.isNotEmpty) {
            await _roleController.setRole(serverActiveRole);
          }
        }
      }

      _logger.d('Available roles: $availableRoles, Active: $activeRole');
    } catch (e) {
      _logger.e('Failed to fetch roles: $e');
      ToastMessageHelper.showToastMessage(
        'Could not load your roles. Pull to retry.',
        title: 'Error',
      );
    } finally {
      isLoadingRoles.value = false;
    }
  }

  void _applyRoles(List<dynamic> roles) {
    final normalized =
        roles.map((r) => r.toString().toUpperCase()).toSet().toList();
    availableRoles.assignAll(normalized);
    _roleController.setUserRoles(normalized);
  }

  /// Switch to a different role
  Future<void> switchRole(String role, BuildContext context) async {
    if (role.toUpperCase() == activeRole.toUpperCase()) return; // Already active

    isSwitching.value = true;
    try {
      final response = await _authRepository.changeRole(role);
      final success = response['success'] as bool? ?? false;

      final data = response['data'] as Map<String, dynamic>?;
      final newToken = (data?['accessToken'] as String? ?? '').trim();

      if (!success) {
        ToastMessageHelper.showToastMessage(
          response['message'] as String? ?? 'Failed to switch role',
          title: 'Error',
        );
        return;
      }

      // The new JWT carries the new activeRole — every later request must use
      // it, so refuse to switch locally if the server did not return one.
      if (newToken.isEmpty) {
        _logger.e('change-role returned no accessToken; keeping current role');
        ToastMessageHelper.showToastMessage(
          'Could not switch role. Please try again.',
          title: 'Error',
        );
        return;
      }

      await PrefsHelper.setString(AppConstants.bearerToken, newToken);
      final newRefresh = data?['refreshToken'] as String?;
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await PrefsHelper.setString(AppConstants.refreshToken, newRefresh);
      }

      // Trust the server's echo of the active role over our request.
      final serverRole = (data?['activeRole'] as String? ?? '').trim();
      await _roleController.setRole(serverRole.isEmpty ? role : serverRole);

      ToastMessageHelper.showToastMessage(
        'Switched to ${RoleController.formatRoleName(_roleController.activeRole.value)}',
      );

      // Navigate to main screen so the new role takes effect
      // The MainNavigationScreen will rebuild with the new role UI
      if (context.mounted) {
        context.go(AppRoutes.mainNavigationScreen);
      }
    } catch (e) {
      _logger.e('Failed to switch role: $e');
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      ToastMessageHelper.showToastMessage(
        msg.isEmpty ? 'Could not switch role. Please try again.' : msg,
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
