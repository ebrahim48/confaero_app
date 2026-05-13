import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../data/repositories/auth_repository.dart';

class SignUpController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final signUpFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedTab = 1.obs;

  final LoggerHelper _logger = LoggerHelper('SignUpController');

  final AuthRepository _authRepository = AuthRepository(
    connectivityService: Get.find(),
    apiService: Get.find(),
  );

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
      // Clear all fields before navigating
      clearFields();
      // Navigate first, then controller will be disposed automatically
      context.go(AppRoutes.signInScreen);
    }
  }

  /// Clear all text fields
  void clearFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your full name";
    }
    if (value.trim().length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    _logger.i('Sign up attempt for: ${emailController.text.trim()}');

    try {
      final response = await _authRepository.register(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? 'Registration successful';

      if (success) {
        _logger.i('Registration successful for: ${emailController.text.trim()}');
        
        await Future.delayed(const Duration(milliseconds: 100));
        if (!context.mounted) return;
        _logger.i('Navigating to verify screen for account activation');
        context.pushNamed(
          AppRoutes.accountVerifyScreen,
          queryParameters: {'email': emailController.text.trim()},
        );
      } else {
        _logger.w('Registration failed: $message');
        ToastMessageHelper.showToastMessage(
          message,
          title: '',
        );
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during registration', error: e);
      
      String errorMessage = e.message;

      // Handle "Account already exist" error
      if (errorMessage.toLowerCase().contains('already exist') ||
          errorMessage.toLowerCase().contains('already registered')) {
        errorMessage = "This email is already registered. Please sign in instead.";
      }

      ToastMessageHelper.showToastMessage(
        errorMessage,
        title: '',
      );
    } catch (e) {
      isLoading.value = false;
      _logger.e('Exception during registration', error: e);

      String errorMessage = e.toString();

      // Handle "Account already exist" error from exception message
      if (errorMessage.toLowerCase().contains('already exist') ||
          errorMessage.toLowerCase().contains('already registered')) {
        errorMessage = "This email is already registered. Please sign in instead.";
      } else if (errorMessage.toLowerCase().contains('no internet')) {
        errorMessage = "No internet connection. Please check your network and try again.";
      } else if (errorMessage.toLowerCase().contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else {
        errorMessage = "Registration failed. Please try again.";
      }

      ToastMessageHelper.showToastMessage(
        errorMessage,
        title: '',
      );
    }
  }

  void signUpWithGoogle() async {
    isLoading.value = true;

    // TODO: Google Sign In API Integration
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
  }
}
