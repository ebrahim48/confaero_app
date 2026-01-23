import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/delete_account_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../passwprd_field_widget.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteAccountController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'Delete Account',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Text
                  CustomText(
                    text: 'Please enter your password to confirm account removal',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    textAlign: TextAlign.start,
                    maxline: 3,
                  ),
                  SizedBox(height: 16.h),

                  // Current Password
                  Obx(() => PasswordFieldWidget(
                    hint: 'Current password',
                    controller: controller.passwordController,
                    isVisible: controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                  )),

                  SizedBox(height: 80.sp),

                  // Warning Text
                  CustomText(
                    text:
                    'This will permanently delete your account and all personal data from our system. This action cannot be undone.',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    textAlign: TextAlign.center,
                    maxline: 4,
                  ),
                  SizedBox(height: 24.h),



                  CustomButton(
                      title: 'Delete Account',
                      onpress: () {

                      },
                    color: AppColors.redColorAC1F1F,
                    borderColor: AppColors.redColorAC1F1F,
                  ),
                  // Delete Account Button

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
