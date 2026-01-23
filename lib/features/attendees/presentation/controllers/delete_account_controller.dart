import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
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

  void deleteAccount() {
    // API call to delete account
    print('Deleting account with password: ${passwordController.text}');

    Get.snackbar('Success', 'Account deleted successfully');
    // Navigate to login or splash screen
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}