import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class ChangePasswordController extends GetxController {
  // Text Controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password visibility
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  final RxBool isLoading = false.obs;
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  Future<void> changePassword() async {
    // Validation
    if (currentPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter current password');
      return;
    }

    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    if (confirmPasswordController.text != newPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    // Password validation regex
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
    );
    if (!passwordRegex.hasMatch(newPasswordController.text)) {
      Get.snackbar(
        'Error',
        'Password must include letters, numbers and special characters (!@#\$%)',
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authRepository.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      final success = response['success'] as bool? ?? false;
      if (success) {
        Get.snackbar('Success', 'Password changed successfully!');
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while changing password');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
