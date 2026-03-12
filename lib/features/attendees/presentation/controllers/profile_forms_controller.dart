import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/domain/services/profile_service.dart';

class ProfileFormsController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();

  // Affiliation Form
  final companyController = TextEditingController();
  final positionTitleController = TextEditingController();
  final fromYearController = TextEditingController();
  final fromMonthController = TextEditingController();
  final toYearController = TextEditingController();
  final toMonthController = TextEditingController();
  final currentlyWorkHere = false.obs;

  // Education Form
  final schoolController = TextEditingController();
  final degreeController = TextEditingController();
  final majorController = TextEditingController();
  final eduFromController = TextEditingController();
  final eduToController = TextEditingController();
  final currentlyStudyHere = false.obs;

  // Location Form
  final fullAddressController = TextEditingController();
  final currentlyLiveHere = false.obs;

  // Contact Form
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final linkedinController = TextEditingController();

  // About Form
  final bioController = TextEditingController();

  // Social Link Form
  final socialLinkController = TextEditingController();

  // Webpage Form
  final webpageController = TextEditingController();

  // Save state
  final isSaving = false.obs;

  @override
  void onClose() {
    companyController.dispose();
    positionTitleController.dispose();
    fromYearController.dispose();
    fromMonthController.dispose();
    toYearController.dispose();
    toMonthController.dispose();
    schoolController.dispose();
    degreeController.dispose();
    majorController.dispose();
    eduFromController.dispose();
    eduToController.dispose();
    fullAddressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    linkedinController.dispose();
    bioController.dispose();
    socialLinkController.dispose();
    webpageController.dispose();
    super.onClose();
  }

  /// Save Affiliation via ProfileService
  Future<void> saveAffiliation() async {
    if (companyController.text.isEmpty ||
        positionTitleController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    try {
      isSaving.value = true;
      await _profileService.updateProfile(
        company: companyController.text,
        title: positionTitleController.text,
      );
      Get.back();
      Get.snackbar('Success', 'Affiliation saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save affiliation');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save Education via ProfileService — maps to title field for now
  Future<void> saveEducation() async {
    if (schoolController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter school name');
      return;
    }

    try {
      isSaving.value = true;
      // education maps to title until the API adds a dedicated field
      await _profileService.updateProfile(
        title: '${schoolController.text} — ${degreeController.text}',
      );
      Get.back();
      Get.snackbar('Success', 'Education saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save education');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save Location via ProfileService — maps to title field for now
  Future<void> saveLocation() async {
    if (fullAddressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter address');
      return;
    }

    try {
      isSaving.value = true;
      await _profileService.updateProfile(title: fullAddressController.text);
      Get.back();
      Get.snackbar('Success', 'Location saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save location');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save Contact via ProfileService — maps available fields
  Future<void> saveContact() async {
    if (phoneController.text.isEmpty && emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter at least one contact');
      return;
    }

    try {
      isSaving.value = true;
      // bio is used as a general-purpose text field to store contact info
      await _profileService.updateProfile(
        bio: 'Phone: ${phoneController.text}, Email: ${emailController.text}',
      );
      Get.back();
      Get.snackbar('Success', 'Contact saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save contact');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save About/Bio via ProfileService
  Future<void> saveAbout() async {
    if (bioController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter bio');
      return;
    }

    try {
      isSaving.value = true;
      await _profileService.updateProfile(bio: bioController.text);
      Get.back();
      Get.snackbar('Success', 'Bio saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save bio');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save Social Link via ProfileService — maps to bio for now
  Future<void> saveSocialLink() async {
    if (socialLinkController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter social link');
      return;
    }

    try {
      isSaving.value = true;
      await _profileService.updateProfile(bio: socialLinkController.text);
      Get.back();
      Get.snackbar('Success', 'Social link saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save social link');
    } finally {
      isSaving.value = false;
    }
  }

  /// Save Webpage via ProfileService — maps to bio for now
  Future<void> saveWebpage() async {
    if (webpageController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter webpage link');
      return;
    }

    try {
      isSaving.value = true;
      await _profileService.updateProfile(bio: webpageController.text);
      Get.back();
      Get.snackbar('Success', 'Webpage saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save webpage');
    } finally {
      isSaving.value = false;
    }
  }
}
