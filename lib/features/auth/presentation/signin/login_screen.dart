import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_text_field.dart';
import '../widgets/divider_widget.dart';
import '../widgets/google_signin_button_widget.dart';
import '../widgets/tab_switcher_widget.dart';
import 'controllers/login_controller.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late final SignInController controller;

  @override
  void initState() {
    super.initState();
    // Always create a fresh controller for signin screen
    if (Get.isRegistered<SignInController>()) {
      Get.delete<SignInController>();
    }
    controller = Get.put(SignInController(), permanent: false);
  }

  @override
  void dispose() {
    // Controller will be disposed by GetX when screen is popped
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: 169.w,
                height: 84.h,
              ),

              SizedBox(height: 32.h),

              // Sign In Now Title
              CustomText(
                text: 'Sign in now',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),

              SizedBox(height: 12.h),

              // Description
              CustomText(
                text: 'Create an account or log in to explore\nabout our app',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 2,
              ),

              SizedBox(height: 24.h),

              // Tab Switcher
              Obx(() => TabSwitcher(
                selectedTab: controller.selectedTab.value,
                onTabChanged: (index) => controller.switchTab(index, context),
              )),

              SizedBox(height: 24.h),

              // Form
              Form(
                key: controller.signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Field
                    CustomText(
                      text: 'Email *',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242,
                      left: 2.w,
                      bottom: 8.h,
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                      contentPaddingHorizontal: 16.w,
                      contentPaddingVertical: 14.h,
                      validator: (value) => controller.validateEmail(value),
                    ),

                    SizedBox(height: 16.h),

                    // Password Field
                    CustomText(
                      text: 'Password *',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242,
                      left: 2.w,
                      bottom: 8.h,
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      contentPaddingHorizontal: 16.w,
                      contentPaddingVertical: 14.h,
                      validator: (value) => controller.validatePassword(value),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => controller.forgotPassword(
                    context,
                    email: controller.emailController.text.trim(),
                  ),
                  child: CustomText(
                    text: 'Forget password',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor32A69A,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Sign In Button
              Obx(() => CustomButton(
                title: 'Log In',
                onpress: () => controller.signInWithEmail(context),
                loading: controller.isLoading.value,
                height: 52.h,
                borderRadius: 10.r,
              )),

              SizedBox(height: 24.h),

              // Or login with divider
              const DividerWithText(text: 'Or login with'),

              SizedBox(height: 24.h),

              // Google Sign In Button
              GoogleSignInButton(
                onTap: controller.signInWithGoogle,
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
