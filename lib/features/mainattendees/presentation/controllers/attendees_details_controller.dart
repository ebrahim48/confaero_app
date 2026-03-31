// lib/features/attendees/controllers/attendee_details_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../domain/services/attendee_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

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
          'canMessage': details.role != 'ATTENDEE' ? false : true,
          'canEmail': details.email?.isNotEmpty ?? false,
        });
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load attendee details', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark() async {
    final wasBookmarked = attendeeDetails['isBookmarked'] ?? false;
    
    try {
      final newStatus = await _attendeeService.bookmarkAttendee(
        SessionController.to.eventId,
        attendeeDetails['id'] ?? '',
      );
      
      attendeeDetails['isBookmarked'] = newStatus;
      attendeeDetails.refresh();
      
      ToastMessageHelper.showToastMessage(
        newStatus ? 'Added to bookmarks' : 'Removed from bookmarks',
        title: 'Bookmark',
      );
    } catch (e) {
      attendeeDetails['isBookmarked'] = wasBookmarked;
      attendeeDetails.refresh();
      ToastMessageHelper.showToastMessage('Failed to update bookmark', title: 'Error');
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
      ToastMessageHelper.showToastMessage('Connection request sent!', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to send request: $e', title: 'Error');
    } finally {
      isRequesting.value = false;
    }
  }
}
