import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/profile_forms_controller.dart';
import '../form_input_widget.dart';

class EducationFormScreen extends StatelessWidget {
  const EducationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Education'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Education'),
                  SizedBox(height: 16.h),
                  FormInputWidget(
                    controller: controller.schoolController,
                    hintText: 'School',
                  ),
                  SizedBox(height: 12.h),
                  FormInputWidget(
                    controller: controller.degreeController,
                    hintText: 'Degree',
                  ),
                  SizedBox(height: 12.h),
                  FormInputWidget(
                    controller: controller.majorController,
                    hintText: 'Major',
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.eduFromController,
                          hintText: 'From',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.eduToController,
                          hintText: 'To',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => _buildCheckbox(
                    'I currently study here',
                    controller.currentlyStudyHere.value,
                        (value) => controller.currentlyStudyHere.value = value ?? false,
                  )),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveEducation(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== LOCATION FORM ==========
class LocationFormScreen extends StatelessWidget {
  const LocationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Location'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Location'),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Full Address *',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                  SizedBox(height: 8.h),
                  FormInputWidget(
                    controller: controller.fullAddressController,
                    hintText: 'Full Address',
                    maxLines: 5,
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => _buildCheckbox(
                    'I currently live here',
                    controller.currentlyLiveHere.value,
                        (value) => controller.currentlyLiveHere.value = value ?? false,
                  )),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveLocation(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== CONTACT FORM ==========
class ContactFormScreen extends StatelessWidget {
  const ContactFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Contact'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Contact'),
                  SizedBox(height: 16.h),
                  FormInputWidget(
                    controller: controller.phoneController,
                    hintText: 'Phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 12.h),
                  FormInputWidget(
                    controller: controller.emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12.h),
                  FormInputWidget(
                    controller: controller.linkedinController,
                    hintText: 'linkedin',
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveContact(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== ABOUT FORM ==========
class AboutFormScreen extends StatelessWidget {
  const AboutFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'About'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('About'),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Bio',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                  SizedBox(height: 8.h),
                  FormInputWidget(
                    controller: controller.bioController,
                    hintText: 'Enter your bio',
                    maxLines: 5,
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveAbout(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== SOCIAL LINK FORM ==========
class SocialLinkFormScreen extends StatelessWidget {
  const SocialLinkFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Social account link'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Social account link'),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Enter social link',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                  SizedBox(height: 8.h),
                  FormInputWidget(
                    controller: controller.socialLinkController,
                    hintText: 'Enter social link',
                    maxLines: 5,
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveSocialLink(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== WEBPAGE FORM ==========
class WebpageFormScreen extends StatelessWidget {
  const WebpageFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Personal webpages'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Personal webpages'),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Enter personal webpage link',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                  SizedBox(height: 8.h),
                  FormInputWidget(
                    controller: controller.webpageController,
                    hintText: 'Enter personal webpage link',
                    maxLines: 5,
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveWebpage(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
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

// ========== HELPER WIDGETS ==========
Widget _buildHeader(BuildContext context, String title) {
  return Container(
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
          Expanded(
            child: CustomText(
              text: title,
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor424242,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xffE1E1E1),
      borderRadius: BorderRadius.circular(4.r),
    ),
    child: CustomText(
      text: title,
      fontsize: 13.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor424242,
    ),
  );
}

Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
  return Row(
    children: [
      SizedBox(
        width: 20.w,
        height: 20.h,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff32A69A),
        ),
      ),
      SizedBox(width: 8.w),
      CustomText(
        text: label,
        fontsize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor424242,
      ),
    ],
  );
}