// lib/features/Events/presentation/controllers/event_spekar_details_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../agenda/domain/services/agenda_service.dart';
import '../../../connection/domain/services/connection_service.dart';

class EventSpekarDetailsController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();
  final ConnectionService _connectionService = Get.find<ConnectionService>();

  // Attendee/speaker details
  final RxMap<String, dynamic> attendeeDetails = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRequesting = false.obs;

  // Event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    // Get speaker ID from route arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['speakerId'] != null) {
        loadSpeakerDetails(args['speakerId'] as String);
      } else {
        attendeeDetails.value = args;
      }
    }
  }

  /// Load speaker details from API
  Future<void> loadSpeakerDetails(String speakerId) async {
    isLoading.value = true;
    try {
      final data = await _agendaService.getSpeakerDetails(
        currentEventId,
        speakerId,
      );
      if (data != null) {
        attendeeDetails.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load speaker details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle bookmark
  void toggleBookmark() {
    attendeeDetails['isBookmarked'] =
        !(attendeeDetails['isBookmarked'] ?? false);
    attendeeDetails.refresh();
  }

  // Say Hi
  void sayHi() {
    // TODO: implement messaging
  }

  // Send Mail
  void sendMail() {
    // TODO: use url_launcher for mailto
  }

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
