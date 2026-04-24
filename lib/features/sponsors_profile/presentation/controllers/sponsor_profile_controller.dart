import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponsorProfileController extends GetxController {
  final RxBool hasProfile = false.obs;

  final RxString logoPath = ''.obs;
  final RxString companyName = 'TchFlow'.obs;
  final RxString description = ''.obs;
  final RxInt descriptionLength = 0.obs;

  final RxInt totalAttendee = 128.obs;
  final RxString profileView = '1.8k'.obs;
  final RxString sponsorStatus = 'Approved'.obs;
  final RxString sponsorDisplayName = 'Tesla'.obs;

  final TextEditingController companyNameController =
  TextEditingController(text: 'TchFlow');
  final TextEditingController descriptionController = TextEditingController(
    text:
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
  );
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController publicEmailController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
    });
    descriptionLength.value = descriptionController.text.length;
  }

  void pickLogo() {
    // image_picker integration point
    // logoPath.value = pickedPath;
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    hasProfile.value = true;
    Get.back();
    Get.snackbar(
      'Success',
      'Profile saved successfully',
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> createProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    hasProfile.value = true;
    Get.back();
    Get.snackbar(
      'Success',
      'Company profile created',
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    companyNameController.dispose();
    descriptionController.dispose();
    websiteUrlController.dispose();
    publicEmailController.dispose();
    super.onClose();
  }
}