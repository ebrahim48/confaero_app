import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/speaker_service.dart';
import '../../../../core/services/video_conference_service.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';

/// Controller for Speaker home screen.
///
/// Manages:
/// - Speaker session invitations
/// - Accepting/rejecting invitations
/// - Live session controls
/// - Speaker dashboard data
class SpeakerHomeController extends GetxController {
  final SpeakerService _speakerService = Get.find<SpeakerService>();
  final VideoConferenceService _videoService = Get.find<VideoConferenceService>();
  final _logger = LoggerHelper('SpeakerHomeController');

  /// Current event ID
  String get eventId => SessionController.to.eventId;

  /// Speaker invitations (pending)
  final RxList<Map<String, dynamic>> invitations = <Map<String, dynamic>>[].obs;

  /// Accepted sessions
  final RxList<Map<String, dynamic>> acceptedSessions =
      <Map<String, dynamic>>[].obs;

  /// Loading states
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  /// Live session state
  final RxBool isLive = false.obs;
  final RxBool isCameraOn = false.obs;
  final Rx<Map<String, dynamic>?> currentLiveSession = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    if (SessionController.to.hasEvent) {
      loadSpeakerData();
    }
  }

  /// Load speaker invitations and sessions
  Future<void> loadSpeakerData() async {
    if (!SessionController.to.hasEvent) return;

    isLoading.value = true;
    try {
      await Future.wait([
        _loadInvitations(),
        _loadAcceptedSessions(),
        _checkLiveSession(),
      ]);
    } catch (e) {
      _logger.e('Failed to load speaker data: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to load speaker data',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load pending invitations
  Future<void> _loadInvitations() async {
    try {
      final data = await _speakerService.getSpeakerInvitations(eventId);
      // Filter pending invitations
      invitations.assignAll(
        data.where((inv) =>
            inv['status']?.toString().toUpperCase() == 'PENDING' ||
            inv['status'] == null).toList(),
      );
    } catch (e) {
      _logger.e('Failed to load invitations: $e');
    }
  }

  /// Load accepted sessions
  Future<void> _loadAcceptedSessions() async {
    try {
      final data = await _speakerService.getMySpeakerSessions(eventId);
      acceptedSessions.assignAll(data);
    } catch (e) {
      _logger.e('Failed to load accepted sessions: $e');
    }
  }

  /// Check if there's an active live session
  Future<void> _checkLiveSession() async {
    try {
      final response = await _videoService.getLiveSession(eventId);
      if (response['success'] == true && response['data'] != null) {
        currentLiveSession.value = response['data'] as Map<String, dynamic>?;
        isLive.value = true;
      }
    } catch (_) {
      // No active session
      isLive.value = false;
      currentLiveSession.value = null;
    }
  }

  /// Accept a speaker invitation
  Future<void> acceptInvitation(String invitationId) async {
    isProcessing.value = true;
    try {
      final response = await _speakerService.acceptSpeakerInvitation(
        invitationId,
        eventId,
      );

      if (response['success'] == true) {
        ToastMessageHelper.showToastMessage(
          'Session invitation accepted!',
          title: 'Success',
        );

        // Reload data
        await loadSpeakerData();
      } else {
        final message =
            response['message'] as String? ?? 'Failed to accept invitation';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to accept invitation: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to accept invitation',
        title: 'Error',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Reject a speaker invitation
  Future<void> rejectInvitation(String invitationId) async {
    isProcessing.value = true;
    try {
      final response = await _speakerService.rejectSpeakerInvitation(
        invitationId,
        eventId,
      );

      if (response['success'] == true) {
        ToastMessageHelper.showToastMessage(
          'Session invitation rejected',
          title: 'Info',
        );

        // Reload data
        await loadSpeakerData();
      } else {
        final message =
            response['message'] as String? ?? 'Failed to reject invitation';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to reject invitation: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to reject invitation',
        title: 'Error',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Start a live session (Go Live)
  Future<void> startLiveSession() async {
    isProcessing.value = true;
    try {
      final response = await _videoService.startSession(eventId);

      if (response['success'] == true) {
        isLive.value = true;
        currentLiveSession.value = response['data'] as Map<String, dynamic>?;
        isCameraOn.value = true;

        ToastMessageHelper.showToastMessage(
          'You are now live!',
          title: 'Success',
        );
      } else {
        final message =
            response['message'] as String? ?? 'Failed to start live session';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to start live session: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to start live session',
        title: 'Error',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Stop live session
  Future<void> stopLiveSession() async {
    isProcessing.value = true;
    try {
      final response = await _videoService.endSession(eventId);

      if (response['success'] == true) {
        isLive.value = false;
        isCameraOn.value = false;
        currentLiveSession.value = null;

        ToastMessageHelper.showToastMessage(
          'Live session ended',
          title: 'Success',
        );
      } else {
        final message =
            response['message'] as String? ?? 'Failed to stop live session';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to stop live session: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to stop live session',
        title: 'Error',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Toggle camera on/off
  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
  }

  /// Join a live session
  Future<void> joinLiveSession() async {
    isProcessing.value = true;
    try {
      final response = await _videoService.joinSession(eventId);

      if (response['success'] == true) {
        // Navigate to live session screen
        Get.toNamed('/liveSessionScreen', arguments: {
          'sessionId': response['data']?['sessionId'],
          'eventTitle': SessionController.to.eventTitle.value,
        });
      } else {
        final message =
            response['message'] as String? ?? 'Failed to join session';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to join live session: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to join live session',
        title: 'Error',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Get a formatted session time
  String formatSessionTime(DateTime? dateTime) {
    if (dateTime == null) return 'Time TBD';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get session status badge color
  Color getStatusColor(String? status) {
    switch (status?.toString().toUpperCase()) {
      case 'ACCEPTED':
        return const Color(0xFF32A69A); // Green
      case 'PENDING':
        return const Color(0xFFFFA500); // Orange
      case 'REJECTED':
        return const Color(0xFFFF0000); // Red
      default:
        return const Color(0xFF757575); // Gray
    }
  }
}
