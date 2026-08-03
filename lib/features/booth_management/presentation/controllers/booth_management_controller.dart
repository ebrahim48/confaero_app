import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/booth_service.dart';

class BoothManagementController extends GetxController {
  final BoothService _service = Get.find<BoothService>();

  final booths = <Map<String, dynamic>>[].obs;
  final myBooth = Rxn<Map<String, dynamic>>();
  final staffMembers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Exhibitor form
  final boothNameController = TextEditingController();
  final boothDescController = TextEditingController();

  String currentEventId = '';
  bool isOrganizer = false;

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    isOrganizer = Get.arguments?['isOrganizer'] as bool? ?? false;
    if (currentEventId.isNotEmpty) {
      isOrganizer ? loadOrganizerBooths() : loadMyBooth();
    }
  }

  @override
  void onClose() {
    boothNameController.dispose();
    boothDescController.dispose();
    super.onClose();
  }

  // =================== Organizer Methods ===================

  Future<void> loadOrganizerBooths() async {
    try {
      isLoading.value = true;
      final response = await _service.getOrganizerBooths(currentEventId);
      if ((response['success'] as bool? ?? false) && response['data'] is List) {
        booths.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptBooth(String boothId) async {
    try {
      await _service.acceptBooth(boothId);
      ToastMessageHelper.showToastMessage('Booth accepted');
      loadOrganizerBooths();
    } catch (e) {
      _showError(e, 'Could not accept the booth.');
    }
  }

  Future<void> cancelBooth(String boothId) async {
    try {
      await _service.cancelBooth(boothId);
      ToastMessageHelper.showToastMessage('Booth cancelled');
      loadOrganizerBooths();
    } catch (e) {
      _showError(e, 'Could not cancel the booth.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }

  // =================== Exhibitor Methods ===================

  Future<void> loadMyBooth() async {
    try {
      isLoading.value = true;
      final response = await _service.getMyBooth();
      if ((response['success'] as bool? ?? false) && response['data'] != null) {
        myBooth.value = response['data'] as Map<String, dynamic>;
        boothNameController.text = myBooth.value?['name'] as String? ?? '';
        boothDescController.text =
            myBooth.value?['description'] as String? ?? '';

        // Load staff separately
        try {
          final staffResponse = await _service.getBoothStaff(currentEventId);
          if (staffResponse['data'] is List) {
            staffMembers.value =
                (staffResponse['data'] as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
          }
        } catch (_) {}
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMyBooth() async {
    try {
      isSaving.value = true;
      await _service.updateMyBooth(currentEventId, {
        'name': boothNameController.text,
        'description': boothDescController.text,
      });
      ToastMessageHelper.showToastMessage('Booth updated');
    } catch (e) {
      _showError(e, 'Could not save your changes.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addStaff(String email) async {
    try {
      await _service.addBoothStaff(currentEventId, email);
      ToastMessageHelper.showToastMessage('Staff member added');
      loadMyBooth();
    } catch (e) {
      _showError(e, 'Could not add the staff member.');
    }
  }

  Future<void> removeStaff(String staffId) async {
    staffMembers.removeWhere((s) => s['_id'] == staffId);
  }
}
