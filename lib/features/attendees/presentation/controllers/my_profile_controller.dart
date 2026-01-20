import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/view/affiliation_form_screen.dart';
import '../widgets/view/all_forms_screen.dart';

class MyProfileController extends GetxController {
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
  void loadProfileData() {
    isLoading.value = true;

    // Simulate loading from API
    // In real app: await api.getProfile()

    isLoading.value = false;
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
        // Upload to server
        // userAvatar.value = image.path;

        Get.snackbar(
          'Success',
          'Profile picture updated',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
    }
  }

  // Add affiliation
  void addAffiliation(BuildContext context) {
    // Navigate to affiliation form
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AffiliationFormScreen(),
      ),
    );
  }

  // Add education
  void addEducation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EducationFormScreen(),
      ),
    );
  }

  // Add location
  void addLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationFormScreen(),
      ),
    );
  }

  // Add contact
  void addContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactFormScreen(),
      ),
    );
  }

  // Add resume
  Future<void> addResume(BuildContext context) async {
    Get.snackbar(
      'Info',
      'Opening file picker...',
      snackPosition: SnackPosition.BOTTOM,
    );

    await Future.delayed(const Duration(seconds: 1));
    resumeUploaded.value = true;

    Get.snackbar(
      'Success',
      'Resume uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Add bio
  void addBio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutFormScreen(),
      ),
    );
  }

  // Add social link
  void addSocialLink(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SocialLinkFormScreen(),
      ),
    );
  }

  // Add webpage
  void addWebpage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebpageFormScreen(),
      ),
    );
  }

  // Save profile
  Future<void> saveProfile() async {
    try {
      isSaving.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In real app:
      // await api.updateProfile({
      //   'affiliations': affiliations,
      //   'education': education,
      //   'location': location.value,
      //   ...
      // });

      isSaving.value = false;

      Get.snackbar(
        'Success',
        'Profile saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      isSaving.value = false;
      Get.snackbar('Error', 'Failed to save profile');
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
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => onSubmit(controller.text),
          child: Text('Add'),
        ),
      ],
    );
  }
}