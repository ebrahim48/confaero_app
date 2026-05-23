import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/prefs_helper.dart';
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

    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    isLoading.value = true;

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // user cancelled
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCredential.user?.getIdToken(true);

      if (firebaseIdToken == null) throw Exception('Failed to get Firebase ID token');

      _logger.i('Firebase ID token obtained, contacting backend');

      final response = await _authRepository.googleSignIn(idToken: firebaseIdToken);
      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      final data = response['data'] as Map<String, dynamic>?;

      if (success && data != null) {
        final accessToken = data['accessToken'] as String? ?? '';
        final refreshToken = data['refreshToken'] as String? ?? '';
        final roleRaw =
            (data['activeRole'] ?? data['role'] ?? data['userRole']) as String?;
        final activeRole =
            (roleRaw?.trim().isNotEmpty == true)
                ? roleRaw!.trim().toUpperCase()
                : 'ATTENDEE';

        await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
        await PrefsHelper.setString(AppConstants.refreshToken, refreshToken);
        await PrefsHelper.setString(AppConstants.userRole, activeRole);
        await PrefsHelper.setBool(AppConstants.isLogged, true);
        await PrefsHelper.setString(AppConstants.email, googleUser.email);

        Get.find<RoleController>().setRole(activeRole);
        await Get.find<SessionController>().clearEvent();

        await Future.delayed(const Duration(milliseconds: 100));
        if (!context.mounted) return;
        _logger.i('Google sign-up successful, navigating to events screen');
        context.go(AppRoutes.eventsScreen);
      } else {
        final message = response['message'] as String? ?? 'Google sign-in failed';
        _logger.w('Google sign-in failed: $message');
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } on NoInternetException catch (e) {
      isLoading.value = false;
      _logger.e('No internet during Google sign-in', error: e);
      ToastMessageHelper.showToastMessage("No internet connection. Please check your network.", title: 'Error');
    } on TimeoutException catch (e) {
      isLoading.value = false;
      _logger.e('Timeout during Google sign-in', error: e);
      ToastMessageHelper.showToastMessage("Request timed out. Please try again.", title: 'Error');
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during Google sign-in', error: e);
      ToastMessageHelper.showToastMessage(
        e.message.isNotEmpty ? e.message : "Google sign-in failed. Please try again.",
        title: 'Error',
      );
    } catch (e) {
      isLoading.value = false;
      _logger.e('Exception during Google sign-in', error: e);
      final msg = e.toString().toLowerCase();
      if (msg.contains('cancelled') ||
          msg.contains('canceled') ||
          msg.contains('sign_in_canceled')) {
        // user dismissed — no error
      } else if (msg.contains('network') ||
          msg.contains('socket') ||
          msg.contains('no internet')) {
        ToastMessageHelper.showToastMessage("Unable to connect. Please check your network.", title: 'Error');
      } else if (msg.contains('timeout')) {
        ToastMessageHelper.showToastMessage("Request timed out. Please try again.", title: 'Error');
      } else {
        ToastMessageHelper.showToastMessage("Google sign-in failed. Please try again.", title: 'Error');
      }
    }
  }
}
