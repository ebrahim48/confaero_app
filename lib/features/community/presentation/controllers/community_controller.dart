
import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/announcement_model.dart';
// import 'announcement_model.dart';

class CommunityController extends GetxController {
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

      // TODO: Replace with actual API call
      // final response = await ApiService.getAnnouncements();

      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));

      announcements.value = [
        AnnouncementModel(
          icon: Icons.campaign,
          iconColor: Colors.black,
          backgroundColor: const Color(0xFFE8F5E9),
          title: 'Last day registration Announceme...',
          subtitle: 'Official update from event by',
          organizer: '(Organizer)',
          date: 'Last Announcement made 4, Dec 2025',
        ),
        AnnouncementModel(
          icon: Icons.help_outline,
          iconColor: Colors.black,
          backgroundColor: const Color(0xFFFFF3E0),
          title: 'Ask Organizers Anything',
          subtitle: 'Have questions? Ask here',
          date: 'Last Announcement made 4, Dec 2025',
          secondaryIcon: Icons.push_pin,
        ),
        AnnouncementModel(
          icon: Icons.campaign,
          iconColor: Colors.black,
          backgroundColor: const Color(0xFFE8F5E9),
          title: 'Last day registration Announceme...',
          subtitle: 'Official update from event by',
          organizer: '(Organizer)',
          date: 'Last Announcement made 4, Dec 2025',
        ),
      ];

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