// lib/features/Events/presentation/controllers/events_spekar_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../agenda/domain/services/agenda_service.dart';

class EventSpekarController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();

  final TextEditingController searchController = TextEditingController();

  // Total stats
  final RxInt totalAttendees = 0.obs;
  final RxInt bookmarked = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Speakers list
  final RxList<Map<String, dynamic>> attendees = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allAttendees =
      <Map<String, dynamic>>[].obs;

  // Event ID
  final String currentEventId = 'default_event_id';

  @override
  void onInit() {
    super.onInit();
    loadSpeakers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load speakers from agenda API
  Future<void> loadSpeakers() async {
    isLoading.value = true;
    try {
      final sessions = await _agendaService.getEventAgenda(currentEventId);
      // Present sessions as speaker entries
      // TODO: adapt once a dedicated speakers list API is available
      final parsed =
          sessions
              .map(
                (s) => <String, dynamic>{
                  'id': s.id,
                  'name': s.title,
                  'company': s.location,
                  'role': 'Speaker',
                  'sessions': '1 session',
                  'image': 'assets/images/profile.png',
                  'isBookmarked': s.isBookmarked,
                },
              )
              .toList();

      allAttendees.assignAll(parsed);
      attendees.assignAll(parsed);
      totalAttendees.value = parsed.length;
      bookmarked.value = parsed.where((a) => a['isBookmarked'] == true).length;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load speakers',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle bookmark
  void toggleBookmark(String id) {
    final index = attendees.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      attendees[index]['isBookmarked'] = !attendees[index]['isBookmarked'];
      attendees.refresh();
      bookmarked.value =
          attendees.where((a) => a['isBookmarked'] == true).length;
    }
  }

  // Search
  void searchSpeakers(String query) {
    if (query.isEmpty) {
      attendees.assignAll(allAttendees);
    } else {
      attendees.assignAll(
        allAttendees
            .where(
              (a) => a['name'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
  }

  // Say Hi
  void sayHi(String name) {
    // TODO: implement messaging
  }

  // Send Mail
  void sendMail(String name) {
    // TODO: implement email
  }
}
