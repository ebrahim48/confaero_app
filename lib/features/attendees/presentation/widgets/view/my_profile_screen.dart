import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../profile/data/models/profile_model.dart';
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture & Name
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: controller.pendingAvatarFile.value != null
                                    ? Image.file(
                                        controller.pendingAvatarFile.value!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                      )
                                    : controller.isNetworkAvatar.value
                                        ? Image.network(
                                            controller.userAvatar.value,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                          )
                                        : Image.asset(
                                            controller.userAvatar.value,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                                          ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.changeProfilePicture(context),
                                child: Container(
                                  width: 24.w,
                                  height: 24.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff32A69A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.camera_alt, size: 14.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomText(
                            textAlign: TextAlign.start,
                            text: controller.userName.value,
                            fontsize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Affiliation Section
                    _buildSectionHeader('Affiliation'),
                    ...controller.affiliationList.asMap().entries.map((e) =>
                        _affiliationTile(e.value, onDelete: () => controller.removeAffiliation(e.key))),
                    ProfileActionButton(
                      icon: Icons.add,
                      label: 'Add an Affiliation',
                      onTap: () => controller.addAffiliation(context),
                    ),

                    SizedBox(height: 16.h),

                    // Education Section
                    _buildSectionHeader('Education'),
                    ...controller.educationList.asMap().entries.map((e) =>
                        _educationTile(e.value, onDelete: () => controller.removeEducation(e.key))),
                    ProfileActionButton(
                      icon: Icons.add,
                      label: 'Add a school',
                      onTap: () => controller.addEducation(context),
                    ),

                    SizedBox(height: 16.h),

                    // Location Section
                    _buildSectionHeader('Location'),
                    if (controller.locationModel.value != null &&
                        controller.locationModel.value!.address.isNotEmpty)
                      _dismissibleInfoTile(
                        icon: Icons.location_on_outlined,
                        text: controller.locationModel.value!.address,
                        onDelete: () => controller.locationModel.value = null,
                      ),
                    ProfileActionButton(
                      icon: Icons.add,
                      label: controller.locationModel.value != null ? 'Update location' : 'Add location',
                      onTap: () => controller.addLocation(context),
                    ),

                    SizedBox(height: 16.h),

                    // Contact Section
                    _buildSectionHeader('Contact'),
                    if (controller.contactModel.value != null) ...[
                      if (controller.contactModel.value!.phone.isNotEmpty)
                        _infoTile(icon: Icons.phone_outlined, text: controller.contactModel.value!.phone),
                      if (controller.contactModel.value!.mobile.isNotEmpty)
                        _infoTile(icon: Icons.smartphone_outlined, text: controller.contactModel.value!.mobile),
                      if (controller.contactModel.value!.email.isNotEmpty)
                        _infoTile(icon: Icons.email_outlined, text: controller.contactModel.value!.email),
                    ],
                    ProfileActionButton(
                      icon: controller.contactModel.value != null ? Icons.edit_outlined : Icons.add,
                      label: controller.contactModel.value != null ? 'Update Contact' : 'Add Contact',
                      onTap: () => controller.addContact(context),
                    ),

                    SizedBox(height: 16.h),

                    // Resume Section
                    _buildSectionHeader('Resume'),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: CustomText(
                        text: 'Interested in new job opportunities? Upload a resume to open up a door for potential employers!',
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
                    if (controller.pendingResumeFile.value != null)
                      _infoTile(
                        icon: Icons.picture_as_pdf_outlined,
                        text: controller.pendingResumeName.value,
                      )
                    else if (controller.resumeUploaded.value)
                      _infoTile(icon: Icons.attach_file, text: 'Resume uploaded'),
                    ProfileActionButton(
                      icon: (controller.resumeUploaded.value || controller.pendingResumeFile.value != null)
                          ? Icons.delete_outline
                          : Icons.attach_file,
                      label: (controller.resumeUploaded.value || controller.pendingResumeFile.value != null)
                          ? 'Remove resume'
                          : 'Add resume',
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
                    if (controller.bio.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: CustomText(
                          text: controller.bio.value,
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ProfileActionButton(
                      icon: controller.bio.value.isNotEmpty ? Icons.edit_outlined : Icons.add,
                      label: controller.bio.value.isNotEmpty ? 'Edit bio' : 'Add bio',
                      onTap: () => controller.addBio(context),
                    ),

                    SizedBox(height: 16.h),

                    // Social Account Link Section
                    _buildSectionHeader('Social account link'),
                    ...controller.socialLinkList.asMap().entries.map((e) =>
                        _dismissibleInfoTile(
                          icon: Icons.link,
                          text: '${e.value.platform}: ${e.value.url}',
                          onDelete: () => controller.removeSocialLink(e.key),
                        )),
                    ProfileActionButton(
                      icon: Icons.add,
                      label: 'Add social link',
                      onTap: () => controller.addSocialLink(context),
                    ),

                    SizedBox(height: 16.h),

                    // Personal Webpages Section
                    _buildSectionHeader('Personal webpages'),
                    ...controller.webpageList.asMap().entries.map((e) =>
                        _dismissibleInfoTile(
                          icon: Icons.public,
                          text: e.value,
                          onDelete: () => controller.removeWebpage(e.key),
                        )),
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
                        onpress: controller.isSaving.value ? () {} : () => controller.saveProfile(),
                        color: const Color(0xff32A69A),
                        height: 48.h,
                        borderRadius: 8.r,
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
    );
  }

  Widget _infoTile({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textColor7E7F7E),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              text: text,
              fontsize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor424242,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dismissibleInfoTile({
    required IconData icon,
    required String text,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textColor7E7F7E),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              text: text,
              fontsize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor424242,
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 16, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  Widget _affiliationTile(AffiliationModel a, {required VoidCallback onDelete}) {
    final period = [a.from, a.isCurrent ? 'Present' : a.to]
        .where((s) => s.isNotEmpty)
        .join(' – ');
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.business_outlined, size: 16, color: AppColors.textColor7E7F7E),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: a.company,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor424242,
                  textAlign: TextAlign.start,
                ),
                if (a.position.isNotEmpty)
                  CustomText(
                    text: a.position,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    textAlign: TextAlign.start,
                  ),
                if (period.isNotEmpty)
                  CustomText(
                    text: period,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 16, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  Widget _educationTile(EducationModel e, {required VoidCallback onDelete}) {
    final period = [e.from, e.isCurrent ? 'Present' : e.to]
        .where((s) => s.isNotEmpty)
        .join(' – ');
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school_outlined, size: 16, color: AppColors.textColor7E7F7E),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: e.institute,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor424242,
                  textAlign: TextAlign.start,
                ),
                if (e.degree.isNotEmpty || e.major.isNotEmpty)
                  CustomText(
                    text: [e.degree, e.major].where((s) => s.isNotEmpty).join(', '),
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    textAlign: TextAlign.start,
                  ),
                if (period.isNotEmpty)
                  CustomText(
                    text: period,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 16, color: AppColors.textColor7E7F7E),
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
