import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void changePassword() {
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
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$');
    if (!passwordRegex.hasMatch(newPasswordController.text)) {
      Get.snackbar(
        'Error',
        'Password must include letters, numbers and special characters (!@#\$%)',
      );
      return;
    }

    // API call to change password
    print('Current: ${currentPasswordController.text}');
    print('New: ${newPasswordController.text}');

    Get.snackbar('Success', 'Password changed successfully!');
    Get.back();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}