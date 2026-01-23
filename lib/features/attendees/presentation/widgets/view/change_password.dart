import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/change_pasword_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../passwprd_field_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'Change Password',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Text
                  CustomText(
                    text:
                    'Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!@#\$%)',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    textAlign: TextAlign.start,
                    maxline: 5,
                  ),
                  SizedBox(height: 24.h),

                  // Current Password
                  Obx(() => PasswordFieldWidget(
                    hint: 'Current password',
                    controller: controller.currentPasswordController,
                    isVisible: controller.isCurrentPasswordVisible.value,
                    onToggleVisibility: controller.toggleCurrentPasswordVisibility,
                  )),
                  SizedBox(height: 16.h),

                  // New Password
                  Obx(() => PasswordFieldWidget(
                    hint: 'New password',
                    controller: controller.newPasswordController,
                    isVisible: controller.isNewPasswordVisible.value,
                    onToggleVisibility: controller.toggleNewPasswordVisibility,
                  )),
                  SizedBox(height: 16.h),

                  // Re-type New Password
                  Obx(() => PasswordFieldWidget(
                    hint: 'Re-type new password',
                    controller: controller.confirmPasswordController,
                    isVisible: controller.isConfirmPasswordVisible.value,
                    onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                  )),
                  SizedBox(height: 32.h),

                  // Change Password Button
                  CustomButton(
                    title: 'Change Password',
                    onpress: controller.changePassword,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}