import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';

/// Controller for Volunteer QR Scan Screen
class VolunteerQRController extends GetxController
    with SingleGetTickerProviderMixin {
  final _logger = LoggerHelper('VolunteerQRController');

  late AnimationController scanAnimation;
  final MobileScannerController scannerController = MobileScannerController();

  final RxBool flashOn = false.obs;
  final RxBool showHistory = false.obs;
  final RxBool showHelp = false.obs;

  final RxList<Map<String, dynamic>> scanHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    scanAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void toggleFlash() {
    flashOn.value = !flashOn.value;
    scannerController.toggleTorch();
  }

  void handleScan(String? value) {
    if (value == null || value.isEmpty) return;

    _logger.d('Scanned QR: $value');

    // Add to history
    final now = DateTime.now();
    final timeStr = _formatTime(now);

    scanHistory.insert(0, {
      'name': 'Ronald Richards',
      'passId': '#0100123',
      'time': timeStr,
      'rawValue': value,
    });

    ToastMessageHelper.showToastMessage(
      'Attendee checked in successfully!',
      title: '✅ Check In',
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void onClose() {
    scanAnimation.dispose();
    scannerController.dispose();
    super.onClose();
  }
}
