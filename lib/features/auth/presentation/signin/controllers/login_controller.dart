import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/approutes/app_routes.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signInFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedTab = 0.obs; // 0 for Login, 1 for Sign Up

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void switchTab(int index, BuildContext context) {
    selectedTab.value = index;
    // Navigate to signup if index is 1
    if (index == 1) {
      // Dispose of current controller and navigate to signup
      Get.delete<SignInController>();
      context.goNamed(AppRoutes.signUpScreen);
    }
  }

  void signInWithEmail(BuildContext context) async {
    // if (signInFormKey.currentState!.validate()) {
    //   isLoading.value = true;
    //
    //   // TODO: API Integration here
    //   // await authService.signIn(
    //   //   email: emailController.text,
    //   //   password: passwordController.text,
    //   // );
    //
    //   await Future.delayed(const Duration(seconds: 2)); // Simulating API call
    //   isLoading.value = false;
    //
    //   // Navigate to events screen after successful signin
    //
    // }

    context.go(AppRoutes.eventsScreen);
  }

  void signInWithGoogle() async {
    isLoading.value = true;

    // TODO: Google Sign In API Integration
    // await authService.signInWithGoogle();

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Navigate to next screen
    // Get.offAllNamed(AppRoutes.homeScreen);
  }

  void forgotPassword(BuildContext context) {
    context.pushNamed(AppRoutes.forgetPasswordScreen);
  }
}