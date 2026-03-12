// lib/features/attendees/controllers/attendees_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/services/attendee_service.dart';

class AttendeesController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();
  final TextEditingController searchController = TextEditingController();

  // Total stats
  final RxInt totalAttendees = 5.obs;
  final RxInt bookmarked = 3.obs;

  // Attendees list
  final RxList<Map<String, dynamic>> attendees = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendees();
  }

  Future<void> loadAttendees() async {
    try {
      // Hardcoded eventId for Phase 2 demo; in auth/real usage, this should come from route args or active event settings
      final eventId = 'default_event_id';
      final data = await _attendeeService.getEventAttendees(eventId);

      attendees.value =
          data
              .map(
                (a) => {
                  'id': a.id,
                  'name': a.name,
                  'company': a.company,
                  'role': a.role,
                  'sessions': '${a.sessionsCount} sessions',
                  'image':
                      a.avatarUrl.isNotEmpty
                          ? a.avatarUrl
                          : 'assets/images/profile.png',
                  'isBookmarked': a.isBookmarked,
                },
              )
              .toList();

      totalAttendees.value = attendees.length;
      bookmarked.value =
          attendees.where((a) => a['isBookmarked'] == true).length;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load attendees',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Toggle bookmark
  Future<void> toggleBookmark(String id) async {
    final index = attendees.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      final wasBookmarked = attendees[index]['isBookmarked'];
      attendees[index]['isBookmarked'] = !wasBookmarked;
      attendees.refresh();
      bookmarked.value =
          attendees.where((a) => a['isBookmarked'] == true).length;

      try {
        await _attendeeService.bookmarkAttendee('default_event_id', id);
      } catch (e) {
        // Revert on error
        attendees[index]['isBookmarked'] = wasBookmarked;
        attendees.refresh();
        bookmarked.value =
            attendees.where((a) => a['isBookmarked'] == true).length;
        Get.snackbar(
          'Error',
          'Failed to bookmark',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Say Hi
  void sayHi(String name) {
    print('Say Hi to $name');
  }

  // Send Mail
  void sendMail(String name) {
    print('Send mail to $name');
  }
}
