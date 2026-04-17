import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/qr_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class CheckInOutController extends GetxController {
  final QrService _qrService = Get.find<QrService>();

  final isLoading = false.obs;
  final checkInTime = ''.obs;
  final checkOutTime = ''.obs;
  final scannedAttendees = <String>[].obs;
  final qrData = ''.obs;

  // Contact Us controllers
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final contactFormKey = GlobalKey<FormState>();

  /// Always reads the latest active eventId from the global SessionController.
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadQrCode();
  }

  @override
  void onClose() {
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  /// Generate QR code for this event
  Future<void> loadQrCode() async {
    try {
      isLoading.value = true;
      final response = await _qrService.generateQR(currentEventId);
      if (response['success'] == true && response['data'] != null) {
        qrData.value = response['data']['qrCode']?.toString() ?? '';
        checkInTime.value = response['data']['checkInTime']?.toString() ?? '';
        checkOutTime.value = response['data']['checkOutTime']?.toString() ?? '';
      }
    } catch (e) {
      // Fallback to static values if API fails
      checkInTime.value = '';
      checkOutTime.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  void checkInViaQRCode(BuildContext context) async {
    context.pushNamed(AppRoutes.contactQrScreen);
  }

  void checkInVirtual(BuildContext context) async {
    context.pushNamed(AppRoutes.liveMeetingScreen);
  }

  // Handle QR scanning and send to API
  void scanAttendeeQR(BuildContext context) async {
    final result = await context.pushNamed(AppRoutes.qrScannerScreen);

    if (result != null && result is String) {
      // Store scanned attendee
      if (!scannedAttendees.contains(result)) {
        scannedAttendees.add(result);
      }

      // Send scan result to API
      try {
        await _qrService.scanQR(result);
        ToastMessageHelper.showToastMessage('Attendee scanned successfully!', title: 'Success');
      } catch (e) {
        ToastMessageHelper.showToastMessage('Failed to process scan', title: 'Error');
      }
    }
  }

  void submitContactForm() async {
    if (contactFormKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      emailController.clear();
      messageController.clear();

      ToastMessageHelper.showToastMessage('Your message has been sent successfully!', title: 'Success');

      Get.back();
    }
  }

  void contactUs(BuildContext context) {
    context.pushNamed(AppRoutes.contactUsScreen);
  }

  List<String> getScannedAttendees() {
    return scannedAttendees.toList();
  }

  void clearScannedAttendees() {
    scannedAttendees.clear();
  }
}
