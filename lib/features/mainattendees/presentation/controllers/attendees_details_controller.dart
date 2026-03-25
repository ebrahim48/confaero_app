// lib/features/attendees/controllers/attendee_details_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../domain/services/attendee_service.dart';

class AttendeeDetailsController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();

  final RxBool isLoading = false.obs;

  // Attendee details
  final RxMap<String, dynamic> attendeeDetails =
      <String, dynamic>{
        'name': '',
        'company': '',
        'role': 'Attendee',
        'sessions': '0 sessions',
        'image': 'assets/images/sampleprofile.png',
        'email': '',
        'phone': '',
        'location': '',
        'isBookmarked': false,
      }.obs;

  /// Call this from the screen, passing eventId and attendeeId from route args
  Future<void> loadAttendeeDetails(String eventId, String attendeeId) async {
    isLoading.value = true;
    try {
      final details = await _attendeeService.getAttendeeDetails(
        eventId,
        attendeeId,
      );
      if (details != null) {
        attendeeDetails.assignAll({
          'id': details.id,
          'name': details.name,
          'company': details.company,
          'role': details.role,
          'sessions': '${details.sessionsCount} sessions',
          'image':
              details.avatarUrl.isNotEmpty
                  ? details.avatarUrl
                  : 'assets/images/sampleprofile.png',
          'email': details.email ?? '',
          'phone': details.phone ?? '',
          'location': details.location ?? '',
          'isBookmarked': details.isBookmarked,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load attendee details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark() async {
    final wasBookmarked = attendeeDetails['isBookmarked'] ?? false;
    attendeeDetails['isBookmarked'] = !wasBookmarked;
    attendeeDetails.refresh();

    try {
      await _attendeeService.bookmarkAttendee(
        SessionController.to.eventId,
        attendeeDetails['id'] ?? '',
      );
    } catch (e) {
      attendeeDetails['isBookmarked'] = wasBookmarked;
      attendeeDetails.refresh();
      Get.snackbar(
        'Error',
        'Failed to bookmark',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Say Hi
  void sayHi() {
    print('Say Hi');
  }

  // Send Mail
  void sendMail() {
    print('Send Mail to ${attendeeDetails['email']}');
  }

  final ConnectionService _connectionService = Get.find<ConnectionService>();
  final RxBool isRequesting = false.obs;

  // Request to Connect
  Future<void> requestToConnect(String eventId) async {
    isRequesting.value = true;
    try {
      await _connectionService.sendRequest(eventId);
      Get.snackbar(
        'Success',
        'Connection request sent!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send request: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRequesting.value = false;
    }
  }
}
