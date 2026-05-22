import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../sponsors/domain/services/sponsor_service.dart';
import '../../../sponsors/data/models/sponsor_model.dart';
import 'package:flutter/material.dart';

class SponsorsController extends GetxController {
  final SponsorService _service = Get.find<SponsorService>();

  final RxList<SponsorModel> sponsors = <SponsorModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSponsors();
  }

  // Read event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  Future<void> fetchSponsors() async {
    isLoading.value = true;
    try {
      final fetched = await _service.getAllSponsors(currentEventId);
      sponsors.assignAll(fetched);
      
      // Show message if no sponsors available
      if (fetched.isEmpty) {
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logSponsorView(String sponsorId) async {
    try {
      await _service.incrementSponsorView(sponsorId);
    } catch (e) {
      debugPrint('Failed to log sponsor view: $e');
    }
  }
}
