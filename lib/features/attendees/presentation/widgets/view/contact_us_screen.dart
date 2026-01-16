import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../controllers/checkin_checkout_controller.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with SingleTickerProviderStateMixin {
  final CheckInOutController controller = Get.put(CheckInOutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: 'Contact Us',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: controller.contactFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    CustomText(
                      text: 'Let us know how can we help you',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff252525),
                      textAlign: TextAlign.start,
                    ),

                    SizedBox(height: 12.h),

                    // Description
                    CustomText(
                      text:
                      'Tell us know in details about your issue, we will get back to you shortly',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff707070),
                      textAlign: TextAlign.center,
                      maxline: 3,
                    ),

                    SizedBox(height: 24.h),

                    // Email Field
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                      borderColor: const Color(0xffE1E1E1),
                      contentPaddingHorizontal: 10.w,
                      contentPaddingVertical: 14.h,
                      borderRadio: 8,
                    ),

                    SizedBox(height: 10.h),

                    // Message Field
                    CustomTextField(
                      controller: controller.messageController,
                      hintText: 'Write your message',
                      maxLine: 5,
                      borderColor: const Color(0xffE1E1E1),
                      contentPaddingHorizontal: 12.w,
                      contentPaddingVertical: 12.h,
                      borderRadio: 8,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Submit Button
                    Obx(() => CustomButton(
                      title: 'Submit',
                      onpress: controller.submitContactForm,
                      loading: controller.isLoading.value,
                      color: const Color(0xff32A69A),
                      height: 48.h,
                      borderRadius: 8.r,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}