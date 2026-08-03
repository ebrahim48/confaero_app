import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
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
    // Permanent + reused (never deleted/recreated): logout flows navigate
    // here then run `Get.deleteAll()` one frame later to reset app state.
    // deleteAll() skips permanent instances, so this avoids disposing this
    // screen's TextEditingControllers while its TextFormFields are still on
    // screen — see SidebarController.logout() and friends.
    if (Get.isRegistered<SignInController>()) {
      controller = Get.find<SignInController>();
      controller.clearFields();
      controller.clearErrors();
    } else {
      controller = Get.put(SignInController(), permanent: true);
    }
  }

  @override
  void dispose() {
    // Controller is permanent — intentionally not deleted here; see initState.
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
                      onChanged: (_) => controller.emailError.value = null,
                    ),
                    Obx(() => controller.emailError.value != null
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 12.w, bottom: 4.h),
                            child: Text(
                              controller.emailError.value!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : const SizedBox.shrink()),

                    SizedBox(height: 8.h),

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
                      onChanged: (_) => controller.passwordError.value = null,
                    ),
                    Obx(() => controller.passwordError.value != null
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 12.w, bottom: 4.h),
                            child: Text(
                              controller.passwordError.value!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (controller.emailController.text.isEmpty) {
                      controller.emailError.value =
                          "Please enter your email to reset password";
                    } else {
                      context.pushNamed(AppRoutes.forgetPasswordScreen,
                          extra: controller.emailController.text);
                    }
                  },
                  child: CustomText(
                    text: 'Forget password',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor32A69A,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Server / connection error
              Obx(() => controller.serverError.value != null
                  ? Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 16.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              controller.serverError.value!,
                              style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),

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
              Obx(() => GoogleSignInButton(
                onTap: () => controller.signInWithGoogle(context),
                isLoading: controller.isGoogleLoading.value,
              )),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
