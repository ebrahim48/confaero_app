import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CheckInOutController extends GetxController {
  final isLoading = false.obs;
  final checkInTime = ''.obs;
  final checkOutTime = ''.obs;
  final scannedAttendees = <String>[].obs;

  // Contact Us controllers
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final contactFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Load check in/out times if available
    checkInTime.value = '10:01 am, June 10, 2025';
    checkOutTime.value = '1:01 pm, June 10, 2025';
  }

  @override
  void onClose() {
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void checkInViaQRCode(BuildContext context) async {
    context.pushNamed(AppRoutes.contactQrScreen);
    // isLoading.value = true;
    // await Future.delayed(const Duration(seconds: 2));
    // isLoading.value = false;
    //
    // // Update check in time
    // checkInTime.value = DateTime.now().toString();
  }

  void checkInVirtual(BuildContext context) async {
    context.pushNamed(AppRoutes.liveMeetingScreen);
  }

  // New method to handle QR scanning
  void scanAttendeeQR(BuildContext context) async {
    final result = await context.pushNamed(AppRoutes.qrScannerScreen);

    if (result != null && result is String) {
      // Store scanned attendee
      if (!scannedAttendees.contains(result)) {
        scannedAttendees.add(result);
      }

      // Show success message
      Get.snackbar(
        'Success',
        'Attendee scanned successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      // You can also call an API here to save the scanned data
      // await saveScannedAttendee(result);
    }
  }

  void submitContactForm() async {
    if (contactFormKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      // Clear form
      emailController.clear();
      messageController.clear();

      // Show success message
      Get.snackbar(
        'Success',
        'Your message has been sent successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back
      Get.back();
    }
  }

  void contactUs(BuildContext context) {
    context.pushNamed(AppRoutes.contactUsScreen);
  }

  // Method to get scanned attendees list
  List<String> getScannedAttendees() {
    return scannedAttendees.toList();
  }

  // Method to clear scanned attendees
  void clearScannedAttendees() {
    scannedAttendees.clear();
  }
}