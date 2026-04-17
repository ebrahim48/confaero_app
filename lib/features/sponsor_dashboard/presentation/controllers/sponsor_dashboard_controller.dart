import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
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
      ToastMessageHelper.showToastMessage('Failed to load dashboard', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSponsor() async {
    if (nameController.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter sponsor name', title: 'Error');
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
      ToastMessageHelper.showToastMessage('Sponsor created', title: 'Success');
      loadDashboard();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to create sponsor', title: 'Error');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> approveSponsor(String sponsorId) async {
    try {
      await _service.approveSponsor(sponsorId);
      ToastMessageHelper.showToastMessage('Sponsor approved', title: 'Success');
      loadDashboard();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to approve sponsor', title: 'Error');
    }
  }

  Future<void> rejectSponsor(String sponsorId) async {
    try {
      await _service.rejectSponsor(sponsorId);
      ToastMessageHelper.showToastMessage('Sponsor rejected', title: 'Success');
      loadDashboard();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to reject sponsor', title: 'Error');
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
