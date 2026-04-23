import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoothStaffController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final RxList<Map<String, dynamic>> staffList = <Map<String, dynamic>>[
    {'name': 'Hariza Williamson', 'image': 'assets/images/profile.png'},
    {'name': 'Hariza Williamson', 'image': 'assets/images/profile.png'},
    {'name': 'Hariza Williamson', 'image': 'assets/images/profile.png'},
  ].obs;

  final RxBool isLoading = false.obs;

  void removeMember(int index) {
    staffList.removeAt(index);
  }

  Future<void> addMember() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    staffList.add({
      'name': emailController.text.trim(),
      'image': 'assets/images/profile.png',
    });
    emailController.clear();
    Get.back();

    Get.snackbar(
      'Success',
      'Member added successfully',
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}