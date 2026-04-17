import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';

/// Controller for Volunteer Home Screen (Events)
class VolunteerHomeController extends GetxController {
  final _logger = LoggerHelper('VolunteerHomeController');
  final ApiService _apiService = Get.find<ApiService>();

  final RxInt tabIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoading = false.obs;

  final RxList<Map<String, dynamic>> myEvents = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> invitedEvents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<void> loadEvents() async {
    isLoading.value = true;
    try {
      final eventId = SessionController.to.eventId;
      if (eventId.isEmpty) {
        isLoading.value = false;
        return;
      }

      // Fetch my events
      final myEventsResponse = await _apiService.get(
        '/attendee/my-event',
      );

      if (myEventsResponse.data is Map<String, dynamic>) {
        final data = myEventsResponse.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] is List) {
          myEvents.value = (data['data'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
      }

      // Fetch invited events (same endpoint, filter by volunteer role)
      // For now, using the same data - backend should provide separate endpoint
      invitedEvents.value = myEvents
          .where((e) => e['role']?.toString().toLowerCase() == 'volunteer')
          .toList();

      if (invitedEvents.isEmpty) {
        // If no volunteer-specific events, show all as invited
        invitedEvents.value = List.from(myEvents);
      }
    } catch (e) {
      _logger.e('Failed to load events: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
