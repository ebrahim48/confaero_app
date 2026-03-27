// lib/features/attendees/controllers/attendees_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/attendee_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AttendeesController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();
  final TextEditingController searchController = TextEditingController();

  // Total stats
  final RxInt totalAttendees = 0.obs;
  final RxInt bookmarked = 0.obs;

  // Attendees list
  final RxList<Map<String, dynamic>> attendees = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendees();
  }

  Future<void> loadAttendees() async {
    try {
      final eventId = SessionController.to.eventId;
      if (eventId.isEmpty) return;
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
      ToastMessageHelper.showToastMessage('Failed to load attendees', title: 'Error');
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
        await _attendeeService.bookmarkAttendee(SessionController.to.eventId, id);
      } catch (e) {
        // Revert on error
        attendees[index]['isBookmarked'] = wasBookmarked;
        attendees.refresh();
        bookmarked.value =
            attendees.where((a) => a['isBookmarked'] == true).length;
        ToastMessageHelper.showToastMessage('Failed to bookmark', title: 'Error');
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
