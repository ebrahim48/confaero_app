import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/logger_helper.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../profile/domain/services/profile_service.dart';
import '../widgets/view/affiliation_form_screen.dart';
import '../widgets/view/all_forms_screen.dart';

class MyProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final _logger = LoggerHelper('MyProfileController');
  // User profile data
  final userName = 'Albert Flamingo'.obs;
  final userAvatar = 'assets/images/profile.png'.obs;

  // Profile sections
  final affiliations = <String>[].obs;
  final education = <String>[].obs;
  final location = ''.obs;
  final contacts = <String>[].obs;
  final resumeUploaded = false.obs;
  final bio = ''.obs;
  final socialLinks = <String>[].obs;
  final webpages = <String>[].obs;

  // Loading state
  final isLoading = false.obs;
  final isSaving = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  // Load profile data
  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;

      // Load user profile and user info
      final profile = await _profileService.getMyProfile();
      final user = await _authRepository.getMe();

      if (profile != null) {
        bio.value = profile.bio;
        location.value = profile.title; // map jobTitle to location for now
        resumeUploaded.value =
            profile.resumeUrl != null && profile.resumeUrl!.isNotEmpty;

        if (profile.profileImage != null && profile.profileImage!.isNotEmpty) {
          userAvatar.value = profile.profileImage!;
        }

        // Additional profile fields
        // affiliations.value = profile.company.isNotEmpty ? [profile.company] : [];
        // socialLinks.value = profile.socialLinks;
      }

      // Parse AuthRepository.getMe() response
      final success = user['success'] as bool? ?? false;
      if (success && user['data'] != null) {
        final userData = user['data'] as Map<String, dynamic>;
        userName.value = userData['name'] as String? ?? 'Unknown User';
      }
    } catch (e) {
      _logger.e('Failed to load profile data: $e');
      Get.snackbar('Error', 'Failed to load profile details');
    } finally {
      isLoading.value = false;
    }
  }

  // Change profile picture
  Future<void> changeProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        isSaving.value = true;
        Get.snackbar('Processing...', 'Uploading profile image');

        final File file = File(image.path);
        final updatedProfile = await _profileService.updateProfile(
          avatarFile: file,
        );

        if (updatedProfile != null && updatedProfile.profileImage != null) {
          userAvatar.value = updatedProfile.profileImage!;
        }

        Get.snackbar('Success', 'Profile picture updated');
      }
    } catch (e) {
      _logger.e('Failed to upload image: $e');
      Get.snackbar('Error', 'Failed to upload image');
    } finally {
      isSaving.value = false;
    }
  }

  // Add affiliation
  void addAffiliation(BuildContext context) {
    // Navigate to affiliation form
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AffiliationFormScreen()),
    );
  }

  // Add education
  void addEducation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EducationFormScreen()),
    );
  }

  // Add location
  void addLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationFormScreen()),
    );
  }

  // Add contact
  void addContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactFormScreen()),
    );
  }

  // Add/remove resume
  Future<void> addResume(BuildContext context) async {
    if (resumeUploaded.value) {
      // Delete resume
      try {
        isSaving.value = true;
        await _profileService.deleteResume();
        resumeUploaded.value = false;
        Get.snackbar(
          'Success',
          'Resume removed',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        _logger.e('Failed to delete resume: $e');
        Get.snackbar(
          'Error',
          'Failed to remove resume',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isSaving.value = false;
      }
    } else {
      Get.snackbar(
        'Info',
        'Opening file picker...',
        snackPosition: SnackPosition.BOTTOM,
      );
      // TODO: Implement file picker and call _profileService.updateProfile(resumeFile: file)
    }
  }

  // Add bio
  void addBio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutFormScreen()),
    );
  }

  // Add social link
  void addSocialLink(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SocialLinkFormScreen()),
    );
  }

  // Add webpage
  void addWebpage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WebpageFormScreen()),
    );
  }

  // Save profile
  Future<void> saveProfile() async {
    try {
      isSaving.value = true;

      // Update basic fields like bio
      await _profileService.updateProfile(
        bio: bio.value,
        title: location.value,
      );

      Get.snackbar('Success', 'Profile saved successfully');
    } catch (e) {
      _logger.e('Failed to save profile: $e');
      Get.snackbar('Error', 'Failed to save profile');
    } finally {
      isSaving.value = false;
    }
  }

  // Build input dialog
  Widget _buildInputDialog({
    required String title,
    required String hint,
    int maxLines = 1,
    required Function(String) onSubmit,
  }) {
    final controller = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        TextButton(
          onPressed: () => onSubmit(controller.text),
          child: Text('Add'),
        ),
      ],
    );
  }
}
