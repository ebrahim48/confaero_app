import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signInFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedTab = 0.obs;

  final emailError = RxnString();
  final passwordError = RxnString();
  final serverError = RxnString();

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

  void clearErrors() {
    emailError.value = null;
    passwordError.value = null;
    serverError.value = null;
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
    clearErrors();

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

        final accessToken = data['accessToken'] as String? ?? '';
        final refreshToken = data['refreshToken'] as String? ?? '';
        final roleRaw = (data['activeRole'] ?? data['role'] ?? data['userRole']) as String?;
        final activeRole = (roleRaw?.trim().isNotEmpty == true) ? roleRaw!.trim().toUpperCase() : 'ATTENDEE';

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

        Get.find<RoleController>().setRole(activeRole);
        await Get.find<SessionController>().clearEvent();

        if (AppConstants.DEMO_MODE) {
          Get.find<SessionController>().setEvent(
            AppConstants.DEMO_EVENT_ID,
            title: AppConstants.DEMO_EVENT_TITLE,
          );
        }

        await Future.delayed(const Duration(milliseconds: 100));
        if (!context.mounted) return;
        _logger.i('Navigating to events screen (user must select an event)');
        context.go(AppRoutes.eventsScreen);
      } else {
        final message = response['message'] as String? ?? 'Login failed';
        _logger.w('Login failed: $message');
        _setFieldError(message);
      }
    } on NoInternetException catch (e) {
      isLoading.value = false;
      _logger.e('No internet during login', error: e);
      serverError.value = "No internet connection. Please check your network.";
    } on TimeoutException catch (e) {
      isLoading.value = false;
      _logger.e('Timeout during login', error: e);
      serverError.value = "Request timed out. Please try again.";
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during login', error: e);
      if (e.statusCode != null && e.statusCode! >= 500) {
        serverError.value =
            "Server is currently unavailable. Please try again later.";
      } else {
        _setFieldError(e.message);
      }
    } catch (e) {
      isLoading.value = false;
      _logger.e('Exception during login', error: e);
      final msg = e.toString().toLowerCase();
      if (msg.contains('socket') ||
          msg.contains('connection refused') ||
          msg.contains('no internet') ||
          msg.contains('network')) {
        serverError.value =
            "Unable to connect to server. Please check your network.";
      } else if (msg.contains('timeout')) {
        serverError.value = "Request timed out. Please try again.";
      } else {
        serverError.value = "Login failed. Please try again.";
      }
    }
  }

  void _setFieldError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid credentials') ||
        lower.contains('incorrect password') ||
        lower.contains('user not found') ||
        lower.contains('wrong password')) {
      passwordError.value = "Invalid email or password. Please try again.";
    } else if (lower.contains('not verified') ||
        lower.contains('verify your email')) {
      emailError.value = "Please verify your email before signing in.";
    } else {
      serverError.value = message;
    }
  }

  void signInWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }
}
