import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../data/repositories/auth_repository.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signInFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedTab = 0.obs;

  final LoggerHelper _logger = LoggerHelper('SignInController');

  final AuthRepository _authRepository = AuthRepository(
    connectivityService: Get.find(),
    apiService: Get.find(),
  );

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void switchTab(int index, BuildContext context) {
    selectedTab.value = index;
    if (index == 1) {
      clearFields();
      context.go(AppRoutes.signUpScreen);
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
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
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<void> signInWithEmail(BuildContext context) async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    _logger.i('Sign in attempt for: ${emailController.text.trim()}');

    try {
      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      final data = response['data'] as Map<String, dynamic>?;

      if (success && data != null) {
        _logger.i('Login successful for: ${emailController.text.trim()}');

        // Save tokens to local storage
        final accessToken = data['accessToken'] as String? ?? '';
        final refreshToken = data['refreshToken'] as String? ?? '';
        final activeRole = data['activeRole'] as String? ?? 'ATTENDEE';

        _logger.d(
          'Tokens received - AccessToken: ${accessToken.substring(0, 20)}...',
        );

        await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
        await PrefsHelper.setString(AppConstants.refreshToken, refreshToken);
        await PrefsHelper.setString(AppConstants.userRole, activeRole);
        await PrefsHelper.setBool(AppConstants.isLogged, true);
        await PrefsHelper.setString(
          AppConstants.email,
          emailController.text.trim(),
        );

        await Future.delayed(const Duration(milliseconds: 100));
        if (!context.mounted) return;
        _logger.i('Navigating to main navigation screen');
        context.go(AppRoutes.eventsScreen);
      } else {
        final errorMessage = response['message'] as String? ?? 'Login failed';
        _logger.w('Login failed: $errorMessage');
        ToastMessageHelper.showToastMessage(errorMessage, title: '');
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during login', error: e);

      String errorMessage = e.message;

      // Handle specific error cases
      if (errorMessage.toLowerCase().contains('invalid credentials') ||
          errorMessage.toLowerCase().contains('incorrect password') ||
          errorMessage.toLowerCase().contains('user not found')) {
        errorMessage = "Invalid email or password. Please try again.";
      } else if (errorMessage.toLowerCase().contains('not verified') ||
          errorMessage.toLowerCase().contains('verify your email')) {
        errorMessage = "Please verify your email before signing in.";
      }

      ToastMessageHelper.showToastMessage(errorMessage, title: '');
    } catch (e) {
      isLoading.value = false;
      _logger.e('Exception during login', error: e);

      String errorMessage = e.toString();

      // Handle specific error cases from exception message
      if (errorMessage.toLowerCase().contains('invalid credentials') ||
          errorMessage.toLowerCase().contains('incorrect password') ||
          errorMessage.toLowerCase().contains('user not found')) {
        errorMessage = "Invalid email or password. Please try again.";
      } else if (errorMessage.toLowerCase().contains('not verified') ||
          errorMessage.toLowerCase().contains('verify your email')) {
        errorMessage = "Please verify your email before signing in.";
      } else if (errorMessage.toLowerCase().contains('no internet')) {
        errorMessage =
            "No internet connection. Please check your network and try again.";
      } else if (errorMessage.toLowerCase().contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else {
        errorMessage = "Login failed. Please try again.";
      }

      ToastMessageHelper.showToastMessage(errorMessage, title: '');
    }
  }

  void signInWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }
}
