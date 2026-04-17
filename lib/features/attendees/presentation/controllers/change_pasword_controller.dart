import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class ChangePasswordController extends GetxController {
  // Text Controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  late final AuthRepository _authRepository;

  // Password visibility
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onInit(){
    super.onInit();
    _authRepository = Get.find<AuthRepository>();
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> changePassword() async {
    // Validation
    if (currentPasswordController.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter current password', title: 'Error');
      return;
    }

    if (newPasswordController.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter new password', title: 'Error');
      return;
    }

    if (newPasswordController.text.length < 6) {
      ToastMessageHelper.showToastMessage('Password must be at least 6 characters', title: 'Error');
      return;
    }

    if (confirmPasswordController.text != newPasswordController.text) {
      ToastMessageHelper.showToastMessage('Passwords do not match', title: 'Error');
      return;
    }

    // Password validation regex
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
    );
    if (!passwordRegex.hasMatch(newPasswordController.text)) {
      ToastMessageHelper.showToastMessage('Password must include letters, numbers and special characters (!@#\$%)', title: 'Error');
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
        ToastMessageHelper.showToastMessage('Password changed successfully!', title: 'Success');
        Get.back();
      } else {
        ToastMessageHelper.showToastMessage(response['message'] ?? 'Failed to change password', title: 'Error');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('An error occurred while changing password', title: 'Error');
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
