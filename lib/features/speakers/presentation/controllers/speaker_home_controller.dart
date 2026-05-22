import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/speaker_service.dart';
import '../../../../core/services/video_conference_service.dart';

class SpeakerHomeController extends GetxController {
  final SpeakerService _speakerService = Get.find<SpeakerService>();
  final VideoConferenceService _videoService = Get.find<VideoConferenceService>();
  final _logger = LoggerHelper('SpeakerHomeController');

  String get eventId => SessionController.to.eventId;

  final invitations = <Map<String, dynamic>>[].obs;
  final acceptedSessions = <Map<String, dynamic>>[].obs;
  final liveSessions = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isProcessing = false.obs;

  int get liveCount =>
      liveSessions.where((s) => s['liveStatus'] == 'LIVE').length;

  @override
  void onInit() {
    super.onInit();
    if (SessionController.to.hasEvent) loadSpeakerData();
  }

  Future<void> loadSpeakerData() async {
    if (!SessionController.to.hasEvent) return;
    isLoading.value = true;
    try {
      await Future.wait([
        _loadInvitations(),
        _loadAcceptedSessions(),
        _loadLiveSessions(),
      ]);
    } catch (e) {
      _logger.e('Failed to load speaker data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadInvitations() async {
    try {
      final data = await _speakerService.getSpeakerInvitations(eventId);
      invitations.assignAll(
        data.where((inv) =>
            inv['status']?.toString().toUpperCase() == 'PENDING' ||
            inv['status'] == null).toList(),
      );
    } catch (e) {
      _logger.e('Failed to load invitations: $e');
    }
  }

  Future<void> _loadAcceptedSessions() async {
    try {
      final data = await _speakerService.getMySpeakerSessions(eventId);
      acceptedSessions.assignAll(data);
    } catch (e) {
      _logger.e('Failed to load accepted sessions: $e');
    }
  }

  Future<void> _loadLiveSessions() async {
    try {
      final response = await _videoService.getLiveSession(eventId);
      final data = response['data'] as Map<String, dynamic>?;
      final raw = data?['sessions'] as List? ?? [];
      liveSessions.assignAll(
        raw.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
    } catch (e) {
      _logger.e('Failed to load live sessions: $e');
      liveSessions.clear();
    }
  }

  void goToLiveSessions(BuildContext context) {
    context.pushNamed(AppRoutes.liveSessionScreen);
  }

  Future<void> acceptInvitation(String invitationId) async {
    isProcessing.value = true;
    try {
      final response = await _speakerService.acceptSpeakerInvitation(
        invitationId,
        eventId,
      );
      if (response['success'] == true) {
        await loadSpeakerData();
      } else {
      }
    } catch (e) {
      _logger.e('Failed to accept invitation: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    isProcessing.value = true;
    try {
      final response = await _speakerService.rejectSpeakerInvitation(
        invitationId,
        eventId,
      );
      if (response['success'] == true) {
        await loadSpeakerData();
      } else {
      }
    } catch (e) {
      _logger.e('Failed to reject invitation: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toString().toUpperCase()) {
      case 'ACCEPTED':
        return const Color(0xFF32A69A);
      case 'PENDING':
        return const Color(0xFFFFA500);
      case 'REJECTED':
        return const Color(0xFFFF0000);
      default:
        return const Color(0xFF757575);
    }
  }
}
