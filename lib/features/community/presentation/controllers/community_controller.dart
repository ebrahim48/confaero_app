import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../announcements/data/models/announcement_model.dart';
import '../../../announcements/domain/services/announcement_service.dart';

class CommunityController extends GetxController {
  final AnnouncementService _service = Get.find<AnnouncementService>();

  // Observable variables
  var announcements = <AnnouncementModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  // Load announcements from API
  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Read event ID from global session state
      final String currentEventId = SessionController.to.eventId;

      final data = await _service.getAnnouncements(currentEventId);
      announcements.value = data;
    } catch (e) {
      errorMessage.value = 'Failed to load announcements';
      Get.snackbar(
        'Error',
        'Failed to load announcements',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh announcements
  Future<void> refreshAnnouncements() async {
    await loadAnnouncements();
  }

  // Handle announcement tap
  void onAnnouncementTap(BuildContext context) {
    context.pushNamed(AppRoutes.organizerAnnouncementsScreen);
  }

  // Add new announcement (if needed)
  void addAnnouncement(AnnouncementModel announcement) {
    announcements.insert(0, announcement);
  }

  // Delete announcement
  void deleteAnnouncement(int index) {
    announcements.removeAt(index);
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
