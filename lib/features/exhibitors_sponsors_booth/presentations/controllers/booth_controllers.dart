import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoothController extends GetxController {
  // Booth state
  final RxBool hasBooth = false.obs;
  final RxString boothName = 'Booth A-12'.obs;
  final RxString boothLocation = 'Main Exhibition Hall'.obs;
  final RxString boothStatus = 'Approved'.obs;
  final RxInt totalLeads = 128.obs;
  final RxInt totalStaff = 2.obs;

  // Booth Profile Form
  final TextEditingController companyNameController =
  TextEditingController(text: 'TchFlow');
  final TextEditingController offerTitleController = TextEditingController();
  final TextEditingController boothOpeningController =
  TextEditingController(text: '7:00 AM- 10 PM');
  final TextEditingController descriptionController = TextEditingController(
      text:
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,');
  final TextEditingController boothNumberController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController publicEmailController = TextEditingController();

  final RxString boothBannerPath = ''.obs;
  final RxList<Map<String, dynamic>> downloadableResources =
      <Map<String, dynamic>>[
        {'name': '2025_Product_Catalog.pdf', 'size': '2.4 MB'}
      ].obs;

  final RxInt descriptionLength = 0.obs;

  // Performance data
  final RxInt totalScans = 142.obs;
  final RxList<Map<String, dynamic>> recentLeads =
      <Map<String, dynamic>>[
        {
          'name': 'Brooklyn Simmons',
          'role': 'VP of Marketing @ TecGlobl',
          'time': '2:30 PM',
          'image': 'assets/images/profile.png',
        },
        {
          'name': 'Guy Hawkins',
          'role': 'VP of Marketing @ TecGlobl',
          'time': '2:30 PM',
          'image': 'assets/images/profile.png',
        },
        {
          'name': 'Devon Lane',
          'role': 'VP of Marketing @ TecGlobl',
          'time': '2:30 PM',
          'image': 'assets/images/profile.png',
        },
      ].obs;

  final RxList<double> weeklyScans = <double>[38, 44, 52, 52, 48, 26].obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
    });
  }

  void createBooth() {
    hasBooth.value = true;
    Get.back();
  }

  void saveBoothChanges() {
    Get.snackbar('Success', 'Booth updated successfully',
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  void removeResource(int index) {
    downloadableResources.removeAt(index);
  }

  @override
  void onClose() {
    companyNameController.dispose();
    offerTitleController.dispose();
    boothOpeningController.dispose();
    descriptionController.dispose();
    boothNumberController.dispose();
    websiteUrlController.dispose();
    publicEmailController.dispose();
    super.onClose();
  }
}