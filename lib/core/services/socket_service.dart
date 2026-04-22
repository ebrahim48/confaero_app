import 'dart:async';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../controllers/session_controller.dart';
import '../helpers/logger_helper.dart';
import '../helpers/prefs_helper.dart';

/// Socket event names matching the backend.
class SocketEvents {
  SocketEvents._();

  // ───────── General Messaging (Incoming) ─────────
  static const String messageNew = 'message:new';
  static const String notificationNew = 'notification:new';
  static const String userOnline = 'user:online';
  static const String userOffline = 'user:offline';
  static const String activeCount = 'active-count';
  static const String error = 'error';

  // ───────── Client → Server ─────────
  static const String sendMessage = 'send-message';
  static const String joinSession = 'event-live:join-session';
  static const String sendLiveMessage = 'event-live:send-message';
  static const String createPoll = 'event-live:create-poll';
  static const String votePoll = 'event-live:vote-poll';
  static const String endSession = 'event-live:session-ended';
  static const String muteAllAttendees = 'event-live:mute-all-attendees';
  static const String unmuteAllAttendees = 'event-live:unmute-all-attendees';
  static const String userStatusUpdate = 'user:status';

  // ───────── Server → Client ─────────
  static const String liveMessageNew = 'event-live:message-new';
  static const String pollCreated = 'event-live:poll-created';
  static const String pollUpdated = 'event-live:poll-updated';
  static const String sessionEnded = 'event-live:session-ended';
  static const String forceMute = 'event-live:force-mute';
  static const String allowUnmute = 'event-live:allow-unmute';
  static const String viewerCount = 'event-live:viewer-count';
}

/// Centralized Socket.IO service.
///
/// Connects to the backend Socket.IO server with auth headers (token + eventid).
/// Exposes reactive streams that controllers can subscribe to.
///
/// Usage:
/// ```dart
/// final socketService = Get.find<SocketService>();
/// socketService.connect();
/// socketService.onNewMessage.listen((data) { ... });
/// ```
class SocketService extends GetxService {
  final _logger = LoggerHelper('SocketService');

  io.Socket? _socket;

  // ───────── Connection state ─────────
  final RxBool isConnected = false.obs;
  final RxInt activeUserCount = 0.obs;

  // ───────── Online users tracking ─────────
  final RxSet<String> onlineUserIds = <String>{}.obs;

  // ───────── Stream controllers for general messaging events ─────────
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _userOnlineController = StreamController<Map<String, dynamic>>.broadcast();
  final _userOfflineController = StreamController<Map<String, dynamic>>.broadcast();
  final _messageSentController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<Map<String, dynamic>>.broadcast();

  // ───────── Stream controllers for Event Live Session ─────────
  final _liveMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _pollCreatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _pollUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _sessionEndedController = StreamController<Map<String, dynamic>>.broadcast();
  final _forceMuteController = StreamController<Map<String, dynamic>>.broadcast();
  final _allowUnmuteController = StreamController<Map<String, dynamic>>.broadcast();
  final _viewerCountController = StreamController<Map<String, dynamic>>.broadcast();

  // ───────── Reactive state for Event Live Session ─────────
  final RxInt liveViewerCount = 0.obs;
  final RxBool isSessionActive = false.obs;
  final RxBool isMutedBySpeaker = false.obs;

  // ───────── General Messaging Streams ─────────

  /// Stream of new incoming messages.
  Stream<Map<String, dynamic>> get onNewMessage => _messageController.stream;

  /// Stream of new notifications.
  Stream<Map<String, dynamic>> get onNewNotification => _notificationController.stream;

  /// Stream of user online events.
  Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;

  /// Stream of user offline events.
  Stream<Map<String, dynamic>> get onUserOffline => _userOfflineController.stream;

  /// Stream of messages successfully sent via Socket.IO.
  Stream<Map<String, dynamic>> get onMessageSent => _messageSentController.stream;

  /// Stream of socket errors.
  Stream<Map<String, dynamic>> get onError => _errorController.stream;

  // ───────── Event Live Session Streams ─────────

  /// Stream of new live session chat messages.
  Stream<Map<String, dynamic>> get onLiveMessage => _liveMessageController.stream;

  /// Stream of new poll creation events.
  Stream<Map<String, dynamic>> get onPollCreated => _pollCreatedController.stream;

  /// Stream of poll update events (votes).
  Stream<Map<String, dynamic>> get onPollUpdated => _pollUpdatedController.stream;

  /// Stream of session ended events.
  Stream<Map<String, dynamic>> get onSessionEnded => _sessionEndedController.stream;

  /// Stream of force mute events (from speaker).
  Stream<Map<String, dynamic>> get onForceMute => _forceMuteController.stream;

  /// Stream of allow unmute events (from speaker).
  Stream<Map<String, dynamic>> get onAllowUnmute => _allowUnmuteController.stream;

  /// Stream of viewer count updates.
  Stream<Map<String, dynamic>> get onViewerCount => _viewerCountController.stream;

  // ───────── Lifecycle ─────────




  Future<void> connect() async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final eventId = SessionController.to.eventId;

    _socket = io.io(
      ApiConstants.socketServerUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
        'token': token,
        'eventId': eventId,
      })
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.onConnect((_) {
      print('✅ Connected');
    });

    _socket!.onConnectError((e) {
      print('❌ Connect Error: $e');
    });
  }


  /// Disconnect and clean up.
  void disconnect() {
    _logger.i('Disconnecting socket');
    emitUserStatus(status: 'offline');
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    isConnected.value = false;
    onlineUserIds.clear();
    activeUserCount.value = 0;
  }

  /// Reconnect with fresh credentials (e.g. after role switch or event change).
  Future<void> reconnect() async {
    disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    await connect();
  }

  // ───────── Core socket listeners ─────────

  void _registerCoreListeners() {
    _socket!.onConnect((_) {
      _logger.i('✅ Socket connected to ${ApiConstants.socketServerUrl}');
      isConnected.value = true;
      emitUserStatus(status: 'online');
    });

    _socket!.onDisconnect((reason) {
      _logger.w('❌ Socket disconnected: $reason');
      isConnected.value = false;
    });

    _socket!.onConnectError((error) {
      _logger.e('🔴 Socket connect error: $error');
      isConnected.value = false;
    });

    _socket!.onError((error) {
      _logger.e('🔴 Socket error: $error');
    });

    _socket!.onReconnect((_) {
      _logger.i('🔄 Socket reconnected');
      isConnected.value = true;
      emitUserStatus(status: 'online');
    });

    _socket!.onReconnectError((error) {
      _logger.e('🔴 Socket reconnect error: $error');
    });

    _socket!.onReconnectFailed((_) {
      _logger.e('🔴 Socket reconnect failed after all attempts');
    });
  }

  // ───────── Business event listeners ─────────

  void _registerEventListeners() {
    // 1. New message
    _socket!.on(SocketEvents.messageNew, (data) {
      _logger.d('message:new → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _messageController.add(parsed);
      }
    });

    // 2. New notification
    _socket!.on(SocketEvents.notificationNew, (data) {
      _logger.d('notification:new → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _notificationController.add(parsed);
      }
    });

    // 3. User came online
    _socket!.on(SocketEvents.userOnline, (data) {
      _logger.d('user:online → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        final userId = parsed['userId']?.toString() ?? '';
        if (userId.isNotEmpty) onlineUserIds.add(userId);
        _userOnlineController.add(parsed);
      }
    });

    // 4. User went offline
    _socket!.on(SocketEvents.userOffline, (data) {
      _logger.d('user:offline → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        final userId = parsed['userId']?.toString() ?? '';
        if (userId.isNotEmpty) onlineUserIds.remove(userId);
        _userOfflineController.add(parsed);
      }
    });

    // 5. Active user count
    _socket!.on(SocketEvents.activeCount, (data) {
      _logger.d('active-count → $data');
      if (data is int) {
        activeUserCount.value = data;
      } else if (data is Map) {
        activeUserCount.value = data['count'] as int? ?? 0;
      }
    });

    // 6. Socket error
    _socket!.on(SocketEvents.error, (data) {
      _logger.e('Socket error event → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _errorController.add(parsed);
      }
    });

    // ───────── Event Live Session Listeners ─────────

    // 10. New live session chat message
    _socket!.on(SocketEvents.liveMessageNew, (data) {
      _logger.d('event-live:message-new → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _liveMessageController.add(parsed);
      }
    });

    // 11. Poll created
    _socket!.on(SocketEvents.pollCreated, (data) {
      _logger.d('event-live:poll-created → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _pollCreatedController.add(parsed);
      }
    });

    // 12. Poll updated (vote)
    _socket!.on(SocketEvents.pollUpdated, (data) {
      _logger.d('event-live:poll-updated → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        _pollUpdatedController.add(parsed);
      }
    });

    // 13. Session ended
    _socket!.on(SocketEvents.sessionEnded, (data) {
      _logger.d('event-live:session-ended → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        isSessionActive.value = false;
        _sessionEndedController.add(parsed);
      }
    });

    // 14. Force mute (speaker muted all)
    _socket!.on(SocketEvents.forceMute, (data) {
      _logger.d('event-live:force-mute → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        isMutedBySpeaker.value = true;
        _forceMuteController.add(parsed);
      }
    });

    // 15. Allow unmute (speaker unmuted all)
    _socket!.on(SocketEvents.allowUnmute, (data) {
      _logger.d('event-live:allow-unmute → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        isMutedBySpeaker.value = false;
        _allowUnmuteController.add(parsed);
      }
    });

    // 16. Viewer count
    _socket!.on(SocketEvents.viewerCount, (data) {
      _logger.d('event-live:viewer-count → $data');
      final parsed = _toMap(data);
      if (parsed != null) {
        final count = parsed['count'] as int? ?? 0;
        liveViewerCount.value = count;
        _viewerCountController.add(parsed);
      }
    });
  }

  // ───────── Helpers ─────────

  /// Safely cast socket data to a Map.
  Map<String, dynamic>? _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is List && data.isNotEmpty) return _toMap(data.first);
    return null;
  }

  /// Check if a specific user is online.
  bool isUserOnline(String userId) => onlineUserIds.contains(userId);

  // ───────── Emit (outgoing) methods ─────────

  /// Send a direct message via Socket.IO `send-message` event.
  /// Backend payload: { receiverId, text, attachments? }
  void emitSendMessage({
    required String receiverId,
    required String text,
    List<String>? attachments,
  }) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot emit message: socket not connected');
      return;
    }
    final payload = <String, dynamic>{
      'receiverId': receiverId,
      'text': text,
      if (attachments != null && attachments.isNotEmpty) 'attachments': attachments,
    };
    _logger.d('send-message → $payload');
    _socket!.emit(SocketEvents.sendMessage, payload);
  }

  /// Emit user status update.
  void emitUserStatus({required String status}) {
    _socket?.emit(SocketEvents.userStatusUpdate, {'status': status});
  }

  /// Generic emit method for custom events.
  void emitEvent(String eventName, [dynamic data]) {
    _socket?.emit(eventName, data);
  }

  // ───────── Event Live Session Emit Methods ─────────

  /// Join a live session room to receive live updates.
  ///
  /// Must be called before any other live session operations.
  void emitJoinLiveSession({required int sessionIndex}) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot join session: socket not connected');
      return;
    }

    _logger.d('Joining live session: $sessionIndex');
    _socket!.emit(SocketEvents.joinSession, {'sessionIndex': sessionIndex});
    isSessionActive.value = true;
  }

  /// Send a message in the live session chat.
  ///
  /// Returns `true` if the message was sent successfully.
  bool emitLiveMessage({required int sessionIndex, required String text}) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot send live message: socket not connected');
      return false;
    }

    if (text.trim().isEmpty) {
      _logger.w('Cannot send empty live message');
      return false;
    }

    try {
      _logger.d('Sending live message: session=$sessionIndex, text=$text');
      _socket!.emit(SocketEvents.sendLiveMessage, {
        'sessionIndex': sessionIndex,
        'text': text.trim(),
      });
      return true;
    } catch (e) {
      _logger.e('Failed to send live message: $e');
      return false;
    }
  }

  /// Create a poll in the live session (SPEAKER ONLY).
  ///
  /// Returns `true` if the poll was created successfully.
  bool emitCreatePoll({
    required int sessionIndex,
    required String question,
    required List<String> options,
  }) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot create poll: socket not connected');
      return false;
    }

    try {
      _logger.d('Creating poll in session $sessionIndex');
      _socket!.emit(SocketEvents.createPoll, {
        'sessionIndex': sessionIndex,
        'question': question.trim(),
        'options': options,
      });
      return true;
    } catch (e) {
      _logger.e('Failed to create poll: $e');
      return false;
    }
  }

  /// Vote on a poll option.
  ///
  /// Returns `true` if the vote was cast successfully.
  bool emitVotePoll({
    required int sessionIndex,
    required String pollId,
    required int optionIndex,
  }) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot vote on poll: socket not connected');
      return false;
    }

    try {
      _logger.d('Voting on poll $pollId, option $optionIndex');
      _socket!.emit(SocketEvents.votePoll, {
        'sessionIndex': sessionIndex,
        'pollId': pollId,
        'optionIndex': optionIndex,
      });
      return true;
    } catch (e) {
      _logger.e('Failed to vote on poll: $e');
      return false;
    }
  }

  /// End the live session (SPEAKER ONLY).
  ///
  /// Returns `true` if the session end request was sent successfully.
  bool emitEndSession({required int sessionIndex}) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot end session: socket not connected');
      return false;
    }

    try {
      _logger.d('Ending session $sessionIndex');
      _socket!.emit(SocketEvents.endSession, {'sessionIndex': sessionIndex});
      isSessionActive.value = false;
      return true;
    } catch (e) {
      _logger.e('Failed to end session: $e');
      return false;
    }
  }

  /// Mute all attendees in the session (SPEAKER ONLY).
  ///
  /// Returns `true` if the mute request was sent successfully.
  bool emitMuteAllAttendees({required int sessionIndex}) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot mute attendees: socket not connected');
      return false;
    }

    try {
      _logger.d('Muting all attendees in session $sessionIndex');
      _socket!.emit(SocketEvents.muteAllAttendees, {'sessionIndex': sessionIndex});
      return true;
    } catch (e) {
      _logger.e('Failed to mute attendees: $e');
      return false;
    }
  }

  /// Unmute all attendees in the session (SPEAKER ONLY).
  ///
  /// Returns `true` if the unmute request was sent successfully.
  bool emitUnmuteAllAttendees({required int sessionIndex}) {
    if (_socket == null || !_socket!.connected) {
      _logger.w('Cannot unmute attendees: socket not connected');
      return false;
    }

    try {
      _logger.d('Unmuting all attendees in session $sessionIndex');
      _socket!.emit(SocketEvents.unmuteAllAttendees, {'sessionIndex': sessionIndex});
      return true;
    } catch (e) {
      _logger.e('Failed to unmute attendees: $e');
      return false;
    }
  }

  // ───────── Dispose ─────────

  @override
  void onClose() {
    disconnect();
    _messageController.close();
    _notificationController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _messageSentController.close();
    _errorController.close();
    _liveMessageController.close();
    _pollCreatedController.close();
    _pollUpdatedController.close();
    _sessionEndedController.close();
    _forceMuteController.close();
    _allowUnmuteController.close();
    _viewerCountController.close();
    super.onClose();
  }
}
