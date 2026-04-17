import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/helpers/logger_helper.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../profile/domain/services/profile_service.dart';
import '../widgets/view/affiliation_form_screen.dart';
import '../widgets/view/all_forms_screen.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class MyProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final _logger = LoggerHelper('MyProfileController');

  // ── Display ──────────────────────────────────────────────────────────────
  final userName = ''.obs;
  // Current avatar: network URL or asset path
  final userAvatar = 'assets/images/profile.png'.obs;
  final isNetworkAvatar = false.obs;

  // ── Pending files (not yet uploaded — sent on Save) ──────────────────────
  final pendingAvatarFile = Rxn<File>();   // local file picked by user
  final pendingResumeFile = Rxn<File>();
  final pendingResumeName = ''.obs;
  final deleteResumeOnSave = false.obs;    // user tapped "Remove resume"

  // ── Editable profile sections ────────────────────────────────────────────
  final affiliationList = <AffiliationModel>[].obs;
  final educationList   = <EducationModel>[].obs;
  final locationModel   = Rxn<LocationModel>();
  final contactModel    = Rxn<ContactModel>();
  final resumeUploaded  = false.obs;
  final resumeUrl       = ''.obs;
  final bio             = ''.obs;
  final socialLinkList  = <SocialLink>[].obs;
  final webpageList     = <String>[].obs;

  final isLoading = false.obs;
  final isSaving  = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  // ── Load ─────────────────────────────────────────────────────────────────

  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;

      final profile = await _profileService.getMyProfile();
      final user    = await _authRepository.getMe();

      if (profile != null) {
        bio.value          = profile.about;
        resumeUploaded.value = profile.resumeUrl != null && profile.resumeUrl!.isNotEmpty;
        resumeUrl.value    = profile.resumeUrl ?? '';
        affiliationList.value = profile.affiliations;
        educationList.value   = profile.education;
        locationModel.value   = profile.location;
        contactModel.value    = profile.contact;
        socialLinkList.value  = profile.socialLinks;
        webpageList.value     = profile.personalWebsites;
        if (profile.name.isNotEmpty) userName.value = profile.name;
        if (profile.avatar != null && profile.avatar!.isNotEmpty) {
          userAvatar.value    = profile.avatar!;
          isNetworkAvatar.value = true;
        }
      }

      // Fallback name from auth response
      final success = user['success'] as bool? ?? false;
      if (success && user['data'] != null && userName.value.isEmpty) {
        final userData    = user['data'] as Map<String, dynamic>;
        final profileData = userData['profile'] as Map<String, dynamic>?;
        final accountData = userData['account'] as Map<String, dynamic>?;
        userName.value    =
            profileData?['name'] as String? ?? accountData?['name'] as String? ?? '';
      }
    } catch (e) {
      _logger.e('Failed to load profile data: $e');
      ToastMessageHelper.showToastMessage('Failed to load profile details', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Avatar — pick locally, show preview, upload on Save ──────────────────

  Future<void> changeProfilePicture(BuildContext context) async {
    final source = await _showImageSourceSheet(context);
    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image == null) return;

    // Store file for Save; show local preview immediately
    pendingAvatarFile.value = File(image.path);
    userAvatar.value        = image.path;
    isNetworkAvatar.value   = false;
  }

  Future<ImageSource?> _showImageSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Resume — pick locally, upload on Save ────────────────────────────────

  Future<void> addResume(BuildContext context) async {
    if (resumeUploaded.value || pendingResumeFile.value != null) {
      // Mark for deletion / clear pending
      pendingResumeFile.value = null;
      pendingResumeName.value = '';
      if (resumeUploaded.value) {
        deleteResumeOnSave.value = true;
        resumeUploaded.value     = false;
        resumeUrl.value          = '';
      }
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        pendingResumeFile.value = File(result.files.single.path!);
        pendingResumeName.value = result.files.single.name;
        deleteResumeOnSave.value = false;
      }
    }
  }

  // ── Sections ─────────────────────────────────────────────────────────────

  Future<void> addAffiliation(BuildContext context) async {
    final result = await Navigator.push<AffiliationModel>(
      context,
      MaterialPageRoute(builder: (_) => const AffiliationFormScreen()),
    );
    if (result != null) affiliationList.add(result);
  }

  void removeAffiliation(int index) => affiliationList.removeAt(index);

  Future<void> addEducation(BuildContext context) async {
    final result = await Navigator.push<EducationModel>(
      context,
      MaterialPageRoute(builder: (_) => const EducationFormScreen()),
    );
    if (result != null) educationList.add(result);
  }

  void removeEducation(int index) => educationList.removeAt(index);

  Future<void> addLocation(BuildContext context) async {
    final result = await Navigator.push<LocationModel>(
      context,
      MaterialPageRoute(builder: (_) => const LocationFormScreen()),
    );
    if (result != null) locationModel.value = result;
  }

  Future<void> addContact(BuildContext context) async {
    final result = await Navigator.push<ContactModel>(
      context,
      MaterialPageRoute(builder: (_) => const ContactFormScreen()),
    );
    if (result != null) contactModel.value = result;
  }

  Future<void> addBio(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => AboutFormScreen(initialBio: bio.value)),
    );
    if (result != null) bio.value = result;
  }

  Future<void> addSocialLink(BuildContext context) async {
    final result = await Navigator.push<SocialLink>(
      context,
      MaterialPageRoute(builder: (_) => const SocialLinkFormScreen()),
    );
    if (result != null) socialLinkList.add(result);
  }

  void removeSocialLink(int index) => socialLinkList.removeAt(index);

  Future<void> addWebpage(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const WebpageFormScreen()),
    );
    if (result != null && result.isNotEmpty) webpageList.add(result);
  }

  void removeWebpage(int index) => webpageList.removeAt(index);

  // ── Save — ONE PATCH with everything ─────────────────────────────────────

  Future<void> saveProfile() async {
    try {
      isSaving.value = true;

      // Delete resume if user removed it
      if (deleteResumeOnSave.value) {
        await _profileService.deleteResume();
        deleteResumeOnSave.value = false;
      }

      final updated = await _profileService.updateFullProfile(
        about:            bio.value,
        affiliations:     affiliationList.toList(),
        education:        educationList.toList(),
        location:         locationModel.value,
        contact:          contactModel.value,
        socialLinks:      socialLinkList.toList(),
        personalWebsites: webpageList.toList(),
        avatarFile:       pendingAvatarFile.value,
        resumeFile:       pendingResumeFile.value,
      );

      if (updated != null) {
        bio.value             = updated.about;
        affiliationList.value = updated.affiliations;
        educationList.value   = updated.education;
        locationModel.value   = updated.location;
        contactModel.value    = updated.contact;
        socialLinkList.value  = updated.socialLinks;
        webpageList.value     = updated.personalWebsites;
        resumeUploaded.value  = updated.resumeUrl != null && updated.resumeUrl!.isNotEmpty;
        resumeUrl.value       = updated.resumeUrl ?? '';

        if (updated.avatar != null && updated.avatar!.isNotEmpty) {
          userAvatar.value      = updated.avatar!;
          isNetworkAvatar.value = true;
        }
      }

      // Clear pending files after successful save
      pendingAvatarFile.value = null;
      pendingResumeFile.value = null;
      pendingResumeName.value = '';

      ToastMessageHelper.showToastMessage('Profile saved successfully', title: 'Success');
    } catch (e) {
      _logger.e('Failed to save profile: $e');
      ToastMessageHelper.showToastMessage('Failed to save profile', title: 'Error');
    } finally {
      isSaving.value = false;
    }
  }
}
