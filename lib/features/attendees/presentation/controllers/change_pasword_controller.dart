import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../auth/data/repositories/auth_repository.dart';

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
    // Validation — every branch tells the user why nothing happened.
    if (currentPasswordController.text.isEmpty) {
      _warn('Enter your current password.');
      return;
    }

    if (newPasswordController.text.isEmpty) {
      _warn('Enter a new password.');
      return;
    }

    if (newPasswordController.text.length < 6) {
      _warn('The new password must be at least 6 characters.');
      return;
    }

    if (confirmPasswordController.text != newPasswordController.text) {
      _warn('The passwords do not match.');
      return;
    }

    // Password validation regex
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
    );
    if (!passwordRegex.hasMatch(newPasswordController.text)) {
      _warn('Use at least one letter, one number and one special character '
          '(@\$!%*#?&).');
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
        ToastMessageHelper.showToastMessage('Password changed');
        Get.back();
      } else {
        ToastMessageHelper.showToastMessage(
          response['message'] as String? ?? 'Could not change your password.',
          title: 'Error',
        );
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      ToastMessageHelper.showToastMessage(
        msg.isEmpty ? 'Could not change your password.' : msg,
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _warn(String message) =>
      ToastMessageHelper.showToastMessage(message, title: 'Warning');

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
