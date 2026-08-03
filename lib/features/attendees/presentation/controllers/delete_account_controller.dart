import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class DeleteAccountController extends GetxController {
  // Text Controller
  final passwordController = TextEditingController();

  // Password visibility
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void showDeleteConfirmationDialog() {
    if (passwordController.text.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Enter your password to confirm.',
        title: 'Warning',
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteAccount();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFAC1F1F),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final RxBool isLoading = false.obs;

  void deleteAccount() async {
    try {
      isLoading.value = true;
      final response = await _authRepository.deleteAccount();

      final success = response['success'] as bool? ?? false;
      if (success) {
        // Clear the stored session, then send the user back to sign in.
        // The app routes with go_router, so Get.offAllNamed would be a no-op.
        await PrefsHelper.remove(AppConstants.bearerToken);
        await PrefsHelper.remove(AppConstants.refreshToken);
        await PrefsHelper.remove(AppConstants.userRole);
        await PrefsHelper.setBool(AppConstants.isLogged, false);

        ToastMessageHelper.showToastMessage('Your account has been deleted');
        AppRoutes.goRouter.go(AppRoutes.signInScreen);

        // Deferred to a post-frame callback so the outgoing screen isn't
        // rebuilt against an already-disposed controller mid-transition —
        // see the same fix in SidebarController.logout().
        WidgetsBinding.instance.addPostFrameCallback((_) => Get.deleteAll());
      } else {
        ToastMessageHelper.showToastMessage(
          response['message'] as String? ?? 'Could not delete your account.',
          title: 'Error',
        );
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      ToastMessageHelper.showToastMessage(
        msg.isEmpty ? 'Could not delete your account.' : msg,
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
