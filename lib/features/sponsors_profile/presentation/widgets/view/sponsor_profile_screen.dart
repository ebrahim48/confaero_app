import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../controllers/sponsor_profile_controller.dart';
import '../sponsor_logo_picker.dart';


class SponsorProfileScreen extends StatelessWidget {
  const SponsorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SponsorProfileController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.textColor252525,
            size: 22.sp,
          ),
        ),
        title: Text(
          'Sponsor Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Logo section
            _sectionTitle('Logo'),
            SizedBox(height: 10.h),
            Obx(() => SponsorLogoPicker(
              logoPath: controller.logoPath.value,
              pickedFile: controller.pickedImageFile.value,
              onTap: controller.pickLogo,
            )),
            SizedBox(height: 4.h),
            Divider(color: AppColors.borderColorD2D2D2),
            SizedBox(height: 16.h),

            // Content section
            _sectionTitle('Content'),
            SizedBox(height: 10.h),

            CustomTextField(
              controller: controller.companyNameController,
              labelText: 'Company Name',
              hintText: 'Company name',
            ),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor252525,
              ),
            ),
            SizedBox(height: 6.h),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 5,
              maxLength: 500,
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textColor424242),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 12.h),
                hintText: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
                hintStyle: TextStyle(
                    fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: AppColors.borderColorD2D2D2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: AppColors.borderColorD2D2D2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: AppColors.borderColorD2D2D2),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Obx(() => Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.descriptionLength.value}/500 characters',
                style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textColor7E7F7E),
              ),
            )),

            SizedBox(height: 12.h),
            Divider(color: AppColors.borderColorD2D2D2),
            SizedBox(height: 16.h),

            // Connect & Resources section
            _sectionTitle('Connect & Resources'),
            SizedBox(height: 10.h),

            CustomTextField(
              controller: controller.websiteUrlController,
              labelText: 'Website URL',
              hintText: 'https://example.com',
              prefixIcon: Icon(Icons.language,
                  size: 18.sp, color: AppColors.textColor7E7F7E),
              keyboardType: TextInputType.url,
            ),
            CustomTextField(
              controller: controller.publicEmailController,
              labelText: 'Public Email',
              hintText: 'https://example.com',
              prefixIcon: Icon(Icons.language,
                  size: 18.sp, color: AppColors.textColor7E7F7E),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 24.h),

            // Button
            Obx(() => CustomButton(
              title: controller.hasProfile.value
                  ? 'Save Changes'
                  : 'Create Company Profile',
              loading: controller.isSaving.value,
              onpress: () {
                if (controller.hasProfile.value) {
                  controller.saveProfile(context);
                } else {
                  controller.createProfile(context);
                }
              },
            )),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor252525,
      ),
    );
  }
}