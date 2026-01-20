import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/my_profile_controller.dart';
import '../profile_action_widget.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  Expanded(
                    child: CustomText(
                      text: 'My Profile',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture & Name
                  Row(
                    children: [
                      // Profile Image with Edit Button
                      Stack(
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Obx(
                                    () => Image.asset(
                                  controller.userAvatar.value,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 40.sp,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Edit Button
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.changeProfilePicture(),
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xff32A69A),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 16.w),

                      // Name
                      Expanded(
                        child: Obx(
                              () => CustomText(
                                textAlign: TextAlign.start,
                            text: controller.userName.value,
                            fontsize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Affiliation Section
                  _buildSectionHeader('Affiliation'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add an Affiliation',
                    onTap: () => controller.addAffiliation(context),
                  ),

                  SizedBox(height: 16.h),

                  // Education Section
                  _buildSectionHeader('Education'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add a school',
                    onTap: () => controller.addEducation(context),
                  ),

                  SizedBox(height: 16.h),

                  // Location Section
                  _buildSectionHeader('Location'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add location',
                    onTap: () => controller.addLocation(context),
                  ),

                  SizedBox(height: 16.h),

                  // Contact Section
                  _buildSectionHeader('Contact'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add Contact',
                    onTap: () => controller.addContact(context),
                  ),

                  SizedBox(height: 16.h),

                  // Resume Section
                  _buildSectionHeader('Resume'),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: CustomText(
                      text:
                      'Interested in new job opportunities? Upload a resume to open up a door for potential employers!',
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ),
                  CustomText(
                    text: '10 MB file size limit. PDF only',
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                  ),
                  SizedBox(height: 8.h),
                  ProfileActionButton(
                    icon: Icons.attach_file,
                    label: 'Add resume',
                    onTap: () => controller.addResume(context),
                  ),

                  SizedBox(height: 16.h),

                  // About Section
                  _buildSectionHeader('About'),
                  CustomText(
                    text: 'Bio',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                  SizedBox(height: 8.h),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add bio',
                    onTap: () => controller.addBio(context),
                  ),

                  SizedBox(height: 16.h),

                  // Social Account Link Section
                  _buildSectionHeader('Social account link'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add social link',
                    onTap: () => controller.addSocialLink(context),
                  ),

                  SizedBox(height: 16.h),

                  // Personal Webpages Section
                  _buildSectionHeader('Personal webpages'),
                  ProfileActionButton(
                    icon: Icons.add,
                    label: 'Add webpage',
                    onTap: () => controller.addWebpage(context),
                  ),

                  SizedBox(height: 32.h),

                  // Save Button
                  Obx(
                        () => CustomButton(
                      title: controller.isSaving.value ? 'Saving...' : 'Save',
                      onpress: controller.isSaving.value
                          ? () {}
                          : () => controller.saveProfile(),
                      color: const Color(0xff32A69A),
                      height: 48.h,
                      borderRadius: 8.r,
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffE0E0E0),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        textAlign: TextAlign.start,
        text: title,
        fontsize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor424242,
      ),
    );
  }
}