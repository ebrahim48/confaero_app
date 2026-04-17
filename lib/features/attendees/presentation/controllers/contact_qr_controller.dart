import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/qr_service.dart';
import 'sidebar_controller.dart';

class ContactQrController extends GetxController {
  final QrService _qrService = Get.find<QrService>();
  final SidebarController _sidebarController = Get.find<SidebarController>();

  // My QR tab
  final isLoadingQr = false.obs;
  final qrToken = ''.obs;

  // Scan tab
  final isScanLoading = false.obs;
  final scanSuccess = false.obs;
  final scanError = ''.obs;

  String get eventId => SessionController.to.eventId;

  String get userName => _sidebarController.userName.value;
  String get userAvatar => _sidebarController.userAvatar.value;
  bool get isNetworkAvatar => _sidebarController.isNetworkAvatar.value;

  @override
  void onInit() {
    super.onInit();
    loadQrToken();
  }

  Future<void> loadQrToken() async {
    try {
      isLoadingQr.value = true;
      qrToken.value = '';
      final response = await _qrService.generateQR(eventId);
      if (response['success'] == true && response['data'] != null) {
        qrToken.value = response['data']['qrToken']?.toString() ?? '';
      }
    } catch (_) {
      qrToken.value = '';
    } finally {
      isLoadingQr.value = false;
    }
  }

  Future<void> scanAttendeeQR(BuildContext context) async {
    scanSuccess.value = false;
    scanError.value = '';

    final result = await context.pushNamed(AppRoutes.qrScannerScreen);
    if (result == null || result is! String || result.isEmpty) return;

    try {
      isScanLoading.value = true;
      final response = await _qrService.scanQR(result, eventId);
      if (response['success'] == true) {
        scanSuccess.value = true;
      } else {
        scanError.value = response['message']?.toString() ?? 'Scan failed';
      }
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          scanError.value = data['message']?.toString() ?? 'Scan failed';
          return;
        }
      }
      scanError.value = 'Failed to process scan. Please try again.';
    } finally {
      isScanLoading.value = false;
    }
  }

  void resetScanState() {
    scanSuccess.value = false;
    scanError.value = '';
  }
}
