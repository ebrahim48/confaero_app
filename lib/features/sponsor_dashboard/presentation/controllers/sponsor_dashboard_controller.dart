import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/sponsor_dashboard_service.dart';

class SponsorDashboardController extends GetxController {
  final SponsorDashboardService _service = Get.find<SponsorDashboardService>();

  final sponsors = <Map<String, dynamic>>[].obs;
  final dashboardStats = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final websiteController = TextEditingController();
  final tierController = TextEditingController();

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadDashboard();
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    websiteController.dispose();
    tierController.dispose();
    super.onClose();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      final response = await _service.getSponsorDashboard(currentEventId);
      if ((response['success'] as bool? ?? false)) {
        dashboardStats.value = response['data'] as Map<String, dynamic>?;
        if (response['data']?['sponsors'] is List) {
          sponsors.value =
              (response['data']['sponsors'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSponsor() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter sponsor name');
      return;
    }
    try {
      isSaving.value = true;
      await _service.createSponsor({
        'name': nameController.text,
        'description': descController.text,
        'website': websiteController.text,
        'tier': tierController.text,
        'eventId': currentEventId,
      });
      _clearForm();
      Get.back();
      Get.snackbar('Success', 'Sponsor created');
      loadDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sponsor');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> approveSponsor(String sponsorId) async {
    try {
      await _service.approveSponsor(sponsorId);
      Get.snackbar('Success', 'Sponsor approved');
      loadDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve sponsor');
    }
  }

  Future<void> rejectSponsor(String sponsorId) async {
    try {
      await _service.rejectSponsor(sponsorId);
      Get.snackbar('Success', 'Sponsor rejected');
      loadDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject sponsor');
    }
  }

  void populateForm(Map<String, dynamic> sponsor) {
    nameController.text = sponsor['name'] as String? ?? '';
    descController.text = sponsor['description'] as String? ?? '';
    websiteController.text = sponsor['website'] as String? ?? '';
    tierController.text = sponsor['tier'] as String? ?? '';
  }

  void _clearForm() {
    nameController.clear();
    descController.clear();
    websiteController.clear();
    tierController.clear();
  }
}
