import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/qr_service.dart';

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
    context.pushNamed(AppRoutes.liveSessionScreen);
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
        await _qrService.scanQR(result, currentEventId);
        ToastMessageHelper.showToastMessage('Attendee checked in');
      } catch (e) {
        final msg = e.toString().replaceAll('Exception: ', '').trim();
        ToastMessageHelper.showToastMessage(
          msg.isEmpty ? 'Check-in failed. Please try again.' : msg,
          title: 'Error',
        );
      }
    }
  }

  void submitContactForm(BuildContext context) async {
    if (contactFormKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      emailController.clear();
      messageController.clear();

      if (context.mounted) Navigator.of(context).pop();
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
