import 'dart:async';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/app_constants.dart';
import '../controllers/session_controller.dart';
import '../helpers/logger_helper.dart';
import '../helpers/prefs_helper.dart';

/// Socket event names matching the backend.
class SocketEvents {
  SocketEvents._();

  // Incoming (listen)
  static const String messageNew = 'message:new';
  static const String notificationNew = 'notification:new';
  static const String userOnline = 'user:online';
  static const String userOffline = 'user:offline';
  static const String activeCount = 'active-count';
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

  // ───────── Stream controllers for incoming events ─────────
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _userOnlineController = StreamController<Map<String, dynamic>>.broadcast();
  final _userOfflineController = StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of new incoming messages.
  Stream<Map<String, dynamic>> get onNewMessage => _messageController.stream;

  /// Stream of new notifications.
  Stream<Map<String, dynamic>> get onNewNotification => _notificationController.stream;

  /// Stream of user online events.
  Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;

  /// Stream of user offline events.
  Stream<Map<String, dynamic>> get onUserOffline => _userOfflineController.stream;

  // ───────── Lifecycle ─────────

  /// Connect to the Socket.IO server.
  ///
  /// Reads the JWT token and current event ID from preferences/session,
  /// then opens the connection with those as extra headers.
  Future<void> connect() async {
    // Avoid double-connect
    if (_socket != null && _socket!.connected) {
      _logger.d('Already connected — skipping');
      return;
    }

    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final eventId = SessionController.to.eventId;

    if (token.isEmpty) {
      _logger.w('No auth token — cannot connect to socket');
      return;
    }

    _logger.i('Connecting to socket server…');

    try {
      _socket = io.io(
        'https://reazul8078.suplify.life',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({
              'token': token,
              'eventid': eventId,
            })
            .build(),
      );

      _registerCoreListeners();
      _registerEventListeners();

      _socket!.connect();
      
      // Set timeout for connection
      Future.delayed(const Duration(seconds: 5), () {
        if (!isConnected.value) {
          _logger.w('Socket connection timeout - continuing without real-time features');
        }
      });
    } catch (e) {
      _logger.w('Socket connection failed: $e. Continuing without real-time features.');
    }
  }

  /// Disconnect and clean up.
  void disconnect() {
    _logger.i('Disconnecting socket');
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
    await connect();
  }

  // ───────── Core socket listeners ─────────

  void _registerCoreListeners() {
    _socket!.onConnect((_) {
      _logger.i('Socket connected ✓');
      isConnected.value = true;
    });

    _socket!.onDisconnect((_) {
      _logger.w('Socket disconnected');
      isConnected.value = false;
    });

    _socket!.onConnectError((error) {
      _logger.e('Socket connection error: $error');
      isConnected.value = false;
    });

    _socket!.onError((error) {
      _logger.e('Socket error: $error');
    });

    _socket!.onReconnect((_) {
      _logger.i('Socket reconnected');
      isConnected.value = true;
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

  // ───────── Dispose ─────────

  @override
  void onClose() {
    disconnect();
    _messageController.close();
    _notificationController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    super.onClose();
  }
}
