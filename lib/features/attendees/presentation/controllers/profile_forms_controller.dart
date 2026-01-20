import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFormsController extends GetxController {
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

  @override
  void onClose() {
    // Dispose all controllers
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

  // Save Affiliation
  void saveAffiliation() {
    if (companyController.text.isEmpty || positionTitleController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    // TODO: Save to backend
    Get.back();
    Get.snackbar('Success', 'Affiliation saved successfully');
  }

  // Save Education
  void saveEducation() {
    if (schoolController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter school name');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Education saved successfully');
  }

  // Save Location
  void saveLocation() {
    if (fullAddressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter address');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Location saved successfully');
  }

  // Save Contact
  void saveContact() {
    if (phoneController.text.isEmpty && emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter at least one contact');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Contact saved successfully');
  }

  // Save About
  void saveAbout() {
    if (bioController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter bio');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Bio saved successfully');
  }

  // Save Social Link
  void saveSocialLink() {
    if (socialLinkController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter social link');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Social link saved successfully');
  }

  // Save Webpage
  void saveWebpage() {
    if (webpageController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter webpage link');
      return;
    }

    Get.back();
    Get.snackbar('Success', 'Webpage saved successfully');
  }
}