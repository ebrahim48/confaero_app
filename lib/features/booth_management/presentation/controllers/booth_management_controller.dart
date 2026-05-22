import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      loadOrganizerBooths();
    } catch (e) {
    }
  }

  Future<void> cancelBooth(String boothId) async {
    try {
      await _service.cancelBooth(boothId);
      loadOrganizerBooths();
    } catch (e) {
    }
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
    } catch (e) {
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addStaff(String email) async {
    try {
      await _service.addBoothStaff(currentEventId, email);
      loadMyBooth();
    } catch (e) {
    }
  }

  Future<void> removeStaff(String staffId) async {
    staffMembers.removeWhere((s) => s['_id'] == staffId);
  }
}
