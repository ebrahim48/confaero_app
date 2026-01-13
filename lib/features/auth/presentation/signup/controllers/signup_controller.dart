import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';

class SignUpController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final signUpFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedTab = 1.obs; // 0 for Login, 1 for Sign Up

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void switchTab(int index, BuildContext context) {
    selectedTab.value = index;
    // Navigate to login if index is 0
    if (index == 0) {
      // Dispose of current controller and navigate to login
      Get.delete<SignUpController>();
      context.goNamed(AppRoutes.signInScreen);
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm password";
    }
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void signUpWithEmail() async {
    if (signUpFormKey.currentState!.validate()) {
      isLoading.value = true;

      // TODO: API Integration here
      // await authService.signUp(
      //   fullName: fullNameController.text,
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call
      isLoading.value = false;

      // Navigate to next screen after successful signup
      // Get.offAllNamed(AppRoutes.homeScreen);
    }
  }

  void signUpWithGoogle() async {
    isLoading.value = true;

    // TODO: Google Sign In API Integration
    // await authService.signInWithGoogle();

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Navigate to next screen
    // Get.offAllNamed(AppRoutes.homeScreen);
  }
}