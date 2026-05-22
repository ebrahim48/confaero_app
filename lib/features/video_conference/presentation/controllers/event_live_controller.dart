import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/controllers/role_controller.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../data/models/live_poll.dart';
import '../../data/models/live_session_events.dart';
import '../../data/models/live_session_message.dart';

/// Controller for Event Live Session features.
///
/// Manages real-time features via Socket.IO:
/// - Live session chat
/// - Polls (create, vote, view results)
/// - Session control (end session - speaker only)
/// - Microphone control (mute/unmute all - speaker only)
///
/// Usage:
/// ```dart
/// final eventLiveCtrl = Get.find<EventLiveController>();
/// eventLiveCtrl.joinSession(sessionIndex: 1);
/// eventLiveCtrl.sendLiveMessage('Hello!');
/// ```
class EventLiveController extends GetxController {
  final _logger = LoggerHelper('EventLiveController');
  final SocketService _socketService = Get.find<SocketService>();

  // ───────── State ─────────

  /// Current session index (required for all live session operations).
  final RxInt currentSessionIndex = 0.obs;

  /// Whether the user has joined a live session.
  final RxBool hasJoinedSession = false.obs;

  /// Live chat messages.
  final RxList<LiveSessionMessage> liveMessages = <LiveSessionMessage>[].obs;

  /// Active polls.
  final RxList<LivePoll> polls = <LivePoll>[].obs;

  /// Currently active poll.
  final Rxn<LivePoll> activePoll = Rxn<LivePoll>();

  /// Viewer count in the session.
  final RxInt viewerCount = 0.obs;

  /// Whether the session is currently active.
  final RxBool isSessionActive = false.obs;

  /// Whether the user is muted by the speaker.
  final RxBool isMutedBySpeaker = false.obs;

  /// Loading state for operations.
  final RxBool isLoading = false.obs;

  /// Text input controller for live chat.
  final RxString messageInput = ''.obs;

  // ───────── Subscriptions ─────────
  StreamSubscription<Map<String, dynamic>>? _liveMessageSub;
  StreamSubscription<Map<String, dynamic>>? _pollCreatedSub;
  StreamSubscription<Map<String, dynamic>>? _pollUpdatedSub;
  StreamSubscription<Map<String, dynamic>>? _sessionEndedSub;
  StreamSubscription<Map<String, dynamic>>? _forceMuteSub;
  StreamSubscription<Map<String, dynamic>>? _allowUnmuteSub;
  StreamSubscription<Map<String, dynamic>>? _viewerCountSub;

  // ───────── Role Check Helpers ─────────

  /// Check if current user is a speaker (can perform speaker-only actions).
  bool get isSpeaker => RoleController.to.isRole('SPEAKER');

  // ───────── Lifecycle ─────────

  @override
  void onInit() {
    super.onInit();
    _registerSocketListeners();
  }

  @override
  void onClose() {
    _cancelSocketSubscriptions();
    messageInput.value = '';
    super.onClose();
  }

  // ───────── Socket Listeners ─────────

  void _registerSocketListeners() {
    // Live chat messages
    _liveMessageSub = _socketService.onLiveMessage.listen((data) {
      _logger.d('Received live message: $data');
      try {
        final message = LiveSessionMessage.fromJson(data);
        liveMessages.add(message);
      } catch (e) {
        _logger.e('Failed to parse live message: $e');
      }
    });

    // Poll created
    _pollCreatedSub = _socketService.onPollCreated.listen((data) {
      _logger.d('Poll created: $data');
      try {
        final poll = LivePoll.fromJson(data);
        polls.add(poll);
        activePoll.value = poll;
      } catch (e) {
        _logger.e('Failed to parse poll: $e');
      }
    });

    // Poll updated (vote)
    _pollUpdatedSub = _socketService.onPollUpdated.listen((data) {
      _logger.d('Poll updated: $data');
      try {
        final update = PollVoteUpdate.fromJson(data);
        _updatePollVote(update.pollId, update.optionIndex);
      } catch (e) {
        _logger.e('Failed to parse poll update: $e');
      }
    });

    // Session ended
    _sessionEndedSub = _socketService.onSessionEnded.listen((data) {
      _logger.d('Session ended: $data');
      isSessionActive.value = false;
      hasJoinedSession.value = false;
    });

    // Force mute (speaker muted all)
    _forceMuteSub = _socketService.onForceMute.listen((data) {
      _logger.d('Force mute received: $data');
      isMutedBySpeaker.value = true;
      try {
        final msg = SpeakerControlMessage.fromJson(data);
      } catch (e) {
      }
    });

    // Allow unmute (speaker unmuted all)
    _allowUnmuteSub = _socketService.onAllowUnmute.listen((data) {
      _logger.d('Allow unmute received: $data');
      isMutedBySpeaker.value = false;
      try {
        final msg = SpeakerControlMessage.fromJson(data);
      } catch (e) {
      }
    });

    // Viewer count
    _viewerCountSub = _socketService.onViewerCount.listen((data) {
      _logger.d('Viewer count: $data');
      try {
        final update = ViewerCountUpdate.fromJson(data);
        viewerCount.value = update.count;
      } catch (e) {
        if (data['count'] is int) {
          viewerCount.value = data['count'] as int;
        }
      }
    });
  }

  void _cancelSocketSubscriptions() {
    _liveMessageSub?.cancel();
    _pollCreatedSub?.cancel();
    _pollUpdatedSub?.cancel();
    _sessionEndedSub?.cancel();
    _forceMuteSub?.cancel();
    _allowUnmuteSub?.cancel();
    _viewerCountSub?.cancel();
  }

  // ───────── Session Management ─────────

  /// Join a live session room.
  ///
  /// Must be called before any other live session operations.
  void joinSession({required int sessionIndex}) {
    try {
      currentSessionIndex.value = sessionIndex;
      _socketService.emitJoinLiveSession(sessionIndex: sessionIndex);
      hasJoinedSession.value = true;
      isSessionActive.value = true;
      _logger.i('Joined live session: $sessionIndex');
    } catch (e) {
      _logger.e('Failed to join session: $e');
    }
  }

  /// Leave the current live session.
  void leaveSession() {
    hasJoinedSession.value = false;
    liveMessages.clear();
    polls.clear();
    activePoll.value = null;
    _logger.i('Left live session');
  }

  /// End the current session (SPEAKER ONLY).
  void endSession() {
    if (!isSpeaker) {
      return;
    }

    try {
      final success = _socketService.emitEndSession(
        sessionIndex: currentSessionIndex.value,
      );
      if (success) {
        isSessionActive.value = false;
        hasJoinedSession.value = false;
      }
    } catch (e) {
      _logger.e('Failed to end session: $e');
    }
  }

  // ───────── Live Chat ─────────

  /// Send a message in the live session chat.
  void sendLiveMessage([String? customMessage]) {
    final text = customMessage ?? messageInput.value;

    if (text.trim().isEmpty) {
      return;
    }

    if (!hasJoinedSession.value) {
      return;
    }

    try {
      final success = _socketService.emitLiveMessage(
        sessionIndex: currentSessionIndex.value,
        text: text,
      );

      if (success) {
        messageInput.value = '';
        _logger.d('Live message sent: $text');
      } else {
      }
    } catch (e) {
      _logger.e('Failed to send live message: $e');
    }
  }

  /// Clear all live chat messages.
  void clearMessages() {
    liveMessages.clear();
  }

  // ───────── Poll Management ─────────

  /// Create a new poll (SPEAKER ONLY).
  void createPoll({
    required String question,
    required List<String> options,
  }) {
    if (!isSpeaker) {
      return;
    }

    if (question.trim().isEmpty || options.length < 2) {
      return;
    }

    try {
      final success = _socketService.emitCreatePoll(
        sessionIndex: currentSessionIndex.value,
        question: question,
        options: options,
      );

      if (success) {
      }
    } catch (e) {
      _logger.e('Failed to create poll: $e');
    }
  }

  /// Vote on a poll option.
  void voteOnPoll({
    required String pollId,
    required int optionIndex,
  }) {
    if (!hasJoinedSession.value) {
      return;
    }

    // Check if user already voted
    final poll = polls.firstWhere(
      (p) => p.id == pollId,
      orElse: () => LivePoll(id: '', question: '', options: []),
    );

    if (poll.hasVoted) {
      return;
    }

    try {
      final success = _socketService.emitVotePoll(
        sessionIndex: currentSessionIndex.value,
        pollId: pollId,
        optionIndex: optionIndex,
      );

      if (success) {
        // Optimistically update UI
        _updatePollVote(pollId, optionIndex);
        _logger.d('Vote cast on poll $pollId, option $optionIndex');
      }
    } catch (e) {
      _logger.e('Failed to vote on poll: $e');
    }
  }

  /// Update poll vote count locally (optimistic update).
  void _updatePollVote(String pollId, int optionIndex) {
    final index = polls.indexWhere((p) => p.id == pollId);
    if (index != -1) {
      // Update the option count
      final poll = polls[index];
      final options = List<PollOption>.from(poll.options);
      options[optionIndex] = PollOption(
        text: options[optionIndex].text,
        count: options[optionIndex].count + 1,
      );

      // Create updated poll
      final updatedPoll = LivePoll(
        id: poll.id,
        question: poll.question,
        options: options,
        selectedOptionIndex: optionIndex,
      );

      polls[index] = updatedPoll;

      // Update active poll if it matches
      if (activePoll.value?.id == pollId) {
        activePoll.value = updatedPoll;
      }
    }
  }

  /// Clear all polls.
  void clearPolls() {
    polls.clear();
    activePoll.value = null;
  }

  // ───────── Microphone Control ─────────

  /// Mute all attendees (SPEAKER ONLY).
  void muteAllAttendees() {
    if (!isSpeaker) {
      return;
    }

    try {
      final success = _socketService.emitMuteAllAttendees(
        sessionIndex: currentSessionIndex.value,
      );
      if (success) {
      }
    } catch (e) {
      _logger.e('Failed to mute attendees: $e');
    }
  }

  /// Unmute all attendees (SPEAKER ONLY).
  void unmuteAllAttendees() {
    if (!isSpeaker) {
      return;
    }

    try {
      final success = _socketService.emitUnmuteAllAttendees(
        sessionIndex: currentSessionIndex.value,
      );
      if (success) {
      }
    } catch (e) {
      _logger.e('Failed to unmute attendees: $e');
    }
  }

  // ───────── Utility Methods ─────────

  /// Reset all state (e.g., when leaving the session screen).
  void reset() {
    leaveSession();
    clearMessages();
    clearPolls();
    isMutedBySpeaker.value = false;
    viewerCount.value = 0;
    isSessionActive.value = false;
  }
}
