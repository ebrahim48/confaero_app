import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

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
      ToastMessageHelper.showToastMessage('Please enter your password', title: 'Error');
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
        // Assume API service and pref clears here or via another service
        ToastMessageHelper.showToastMessage('Account deleted successfully', title: 'Success');
        Get.offAllNamed('/login');
      } else {
        ToastMessageHelper.showToastMessage(response['message'] ?? 'Failed to delete account', title: 'Error');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('An error occurred while deleting account', title: 'Error');
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
