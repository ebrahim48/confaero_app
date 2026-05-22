import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../data/models/message_model.dart' as msgModel;
import '../../domain/services/message_service.dart';
import 'message_controller.dart';
import 'package:confaero_app/features/auth/data/repositories/auth_repository.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String date;
  final bool showTime;
  final String? attachmentUrl;
  final String? attachmentName;
  final String? mimeType;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.date,
    this.showTime = true,
    this.attachmentUrl,
    this.attachmentName,
    this.mimeType,
  });
}

class MessageChatController extends GetxController {
  final MessageService _messageService = Get.find<MessageService>();
  final SocketService _socketService = Get.find<SocketService>();

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messageText = ''.obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  final messages = <ChatMessage>[].obs;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _userOnlineSubscription;
  StreamSubscription<Map<String, dynamic>>? _userOfflineSubscription;
  Timer? _pollTimer;
  bool _isFetchingMessages = false;

  String get currentEventId => SessionController.to.eventId;
  String currentReceiverId = '';
  String currentConversationId = '';
  String _currentUserId = '';

  final receiverName = 'User'.obs;
  final receiverImage = ''.obs;
  final isReceiverOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    messageController.addListener(() {
      messageText.value = messageController.text;
    });
    _messageSubscription =
        _socketService.onNewMessage.listen(_handleSocketMessage);

    _userOnlineSubscription = _socketService.onUserOnline.listen((data) {
      final userId = data['userId']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString() ?? '';
      if (userId.isNotEmpty && userId == currentReceiverId) {
        isReceiverOnline.value = true;
      }
    });

    _userOfflineSubscription = _socketService.onUserOffline.listen((data) {
      final userId = data['userId']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString() ?? '';
      if (userId.isNotEmpty && userId == currentReceiverId) {
        isReceiverOnline.value = false;
      }
    });
  }

  /// Called by the screen in initState with all required params.
  Future<void> init({
    required String receiverId,
    String receiverNameVal = 'User',
    String receiverImageVal = '',
    String conversationId = '',
    DateTime? receiverLastSeen,
  }) async {
    currentReceiverId = receiverId;
    receiverName.value = receiverNameVal;
    receiverImage.value = receiverImageVal;
    currentConversationId = conversationId;
    _currentUserId = await PrefsHelper.getString(AppConstants.userId);
    if (_currentUserId.isEmpty) {
      await _resolveCurrentUserId();
    }

    // Determine initial online status: socket set OR lastSeen within 5 minutes
    final socketOnline = _socketService.isUserOnline(receiverId);
    final recentlyActive = receiverLastSeen != null &&
        DateTime.now().difference(receiverLastSeen).inMinutes < 5;
    isReceiverOnline.value = socketOnline || recentlyActive;

    // Broadcast own presence when entering chat
    _socketService.emitUserStatus(status: 'online');

    // Tell MessageController this conversation is open so refreshes don't restore the badge
    if (conversationId.isNotEmpty) {
      try {
        final mc = Get.find<MessageController>();
        mc.currentOpenConversationId = conversationId;
        mc.clearUnreadForConversation(conversationId);
      } catch (_) {}
      await loadMessages();
    }

    _startPollingIfNeeded();
  }

  Future<void> _resolveCurrentUserId() async {
    try {
      final authRepo = Get.find<AuthRepository>();
      final res = await authRepo.getMe();
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        final id = data['_id']?.toString() ?? data['id']?.toString() ?? '';
        if (id.isNotEmpty) {
          _currentUserId = id;
          await PrefsHelper.setString(AppConstants.userId, id);
        }
      }
    } catch (_) {}
  }

  void _startPollingIfNeeded() {
    _pollTimer?.cancel();
    // Poll every 15s only when socket is not connected
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!_socketService.isConnected.value && currentConversationId.isNotEmpty) {
        _pollNewMessages();
      }
    });
  }

  Future<void> _pollNewMessages() async {
    // Guard: skip if already fetching, sending, or no conversation
    if (_isFetchingMessages || isSending.value || currentConversationId.isEmpty) return;
    _isFetchingMessages = true;
    try {
      final data = await _messageService.getMessages(
        currentConversationId,
        currentEventId,
      );
      // Only update if server has more messages than currently shown
      if (data.length <= messages.length) return;

      final updated = data.map((m) {
        final isMe = _currentUserId.isNotEmpty ? m.senderId == _currentUserId : m.isMe;
        final att = m.attachments.isNotEmpty ? m.attachments.first : null;
        final mime = att?['mimeType']?.toString() ?? '';
        final displayText = m.text.isNotEmpty
            ? m.text
            : (att != null ? '📎 ${att['name'] ?? 'Attachment'}' : '');
        return ChatMessage(
          text: displayText,
          isMe: isMe,
          time: _formatTime(m.createdAt),
          date: _formatDate(m.createdAt),
          showTime: true,
          attachmentUrl: att?['url']?.toString(),
          attachmentName: att?['name']?.toString(),
          mimeType: mime,
        );
      }).toList();

      messages.value = updated;
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (_) {
      // Fail silently
    } finally {
      _isFetchingMessages = false;
    }
  }

  Future<void> loadMessages() async {
    if (currentConversationId.isEmpty || _isFetchingMessages) return;
    _isFetchingMessages = true;
    isLoading.value = true;
    try {
      // Ensure userId is resolved before mapping isMe
      if (_currentUserId.isEmpty) {
        await _resolveCurrentUserId();
      }

      final data = await _messageService.getMessages(
        currentConversationId,
        currentEventId,
      );
      messages.value = data.map((m) {
        final isMe = _currentUserId.isNotEmpty
            ? m.senderId == _currentUserId
            : m.isMe;
        final att = m.attachments.isNotEmpty ? m.attachments.first : null;
        final mime = att?['mimeType']?.toString() ?? '';
        final displayText = m.text.isNotEmpty
            ? m.text
            : (att != null ? '📎 ${att['name'] ?? 'Attachment'}' : '');
        return ChatMessage(
          text: displayText,
          isMe: isMe,
          time: _formatTime(m.createdAt),
          date: _formatDate(m.createdAt),
          showTime: true,
          attachmentUrl: att?['url']?.toString(),
          attachmentName: att?['name']?.toString(),
          mimeType: mime,
        );
      }).toList();

      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

      // Mark unread messages as seen (fire-and-forget, don't block UI)
      unawaited(_markUnreadMessagesAsSeen(data));
    } catch (_) {
    } finally {
      isLoading.value = false;
      _isFetchingMessages = false;
    }
  }

  Future<void> _markUnreadMessagesAsSeen(List<msgModel.MessageModel> msgs) async {
    if (_currentUserId.isEmpty) return;

    // Only mark messages sent by the receiver that we haven't read yet
    final unread = msgs
        .where((m) =>
            m.senderId != _currentUserId &&
            !m.readBy.contains(_currentUserId))
        .toList();

    if (unread.isEmpty) return;

    for (final msg in unread) {
      try {
        await _messageService.markMessageSeen(msg.id, currentEventId);
      } catch (_) {
        // fail silently per message
      }
    }

    // Refresh conversation list so unreadCount badge stays cleared from server
    try {
      await Get.find<MessageController>().loadConversations();
    } catch (_) {}
  }

  void _handleSocketMessage(Map<String, dynamic> data) {
    // Ignore typing/seen meta-events mixed into the same stream
    if (data['isTyping'] != null || data['isSeen'] != null) return;

    final msgConvId = data['conversationId']?.toString() ?? '';
    // If we know our conversationId, only accept messages for it
    if (currentConversationId.isNotEmpty &&
        msgConvId.isNotEmpty &&
        msgConvId != currentConversationId) return;

    if (currentConversationId.isEmpty && msgConvId.isNotEmpty) {
      currentConversationId = msgConvId;
    }

    final senderId = data['senderId']?.toString() ?? '';
    // Already added optimistically if it's from us
    if (senderId == _currentUserId) return;

    final text = data['text']?.toString() ?? data['content']?.toString() ?? '';
    final rawAtt = data['attachments'] as List?;
    final att = rawAtt?.isNotEmpty == true
        ? Map<String, dynamic>.from(rawAtt!.first as Map)
        : null;
    final displayText = att != null
        ? '📎 ${att['name'] ?? 'Attachment'}'
        : text;
    if (displayText.isEmpty) return;

    messages.add(ChatMessage(
      text: displayText,
      isMe: false,
      time: _formatTime(DateTime.now()),
      date: _formatDate(DateTime.now()),
      showTime: true,
      attachmentUrl: att?['url']?.toString(),
    ));

    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);

    // Mark this incoming message as seen immediately
    final msgId = data['_id']?.toString() ?? data['id']?.toString() ?? '';
    if (msgId.isNotEmpty) {
      unawaited(
        _messageService.markMessageSeen(msgId, currentEventId).then((_) async {
          try {
            await Get.find<MessageController>().loadConversations();
          } catch (_) {}
        }).catchError((_) {}),
      );
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;

    // Optimistic add
    final optimistic = ChatMessage(
      text: text,
      isMe: true,
      time: _formatTime(DateTime.now()),
      date: _formatDate(DateTime.now()),
      showTime: true,
    );
    messages.add(optimistic);
    messageController.clear();
    messageText.value = '';
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    try {
      final response = await _messageService.sendMessage(
        currentEventId,
        receiverId: currentReceiverId,
        content: text,
      );

      final data = response['data'] as Map<String, dynamic>?;
      final convId = data?['conversationId']?.toString() ?? '';
      if (convId.isNotEmpty && currentConversationId.isEmpty) {
        currentConversationId = convId;
      }

      // Extract our userId from send response — most reliable source
      if (_currentUserId.isEmpty) {
        final senderId = data?['senderId']?.toString() ?? '';
        if (senderId.isNotEmpty) {
          _currentUserId = senderId;
          await PrefsHelper.setString(AppConstants.userId, senderId);
        }
      }

      // Backend broadcasts message:new via socket after saving — no need to emit separately
    } catch (_) {
      messages.remove(optimistic);
      messages.refresh();
    } finally {
      isSending.value = false;
    }
  }

  Future<void> pickAndSendAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    final optimistic = ChatMessage(
      text: '📎 $fileName',
      isMe: true,
      time: _formatTime(DateTime.now()),
      date: _formatDate(DateTime.now()),
      showTime: true,
    );
    messages.add(optimistic);
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    try {
      final response = await _messageService.sendMessage(
        currentEventId,
        receiverId: currentReceiverId,
        content: fileName,
        attachmentFile: file,
      );
      // Replace optimistic with real message that has the attachment URL
      final msgData = response['data'] as Map<String, dynamic>?;
      final convId = msgData?['conversationId']?.toString() ?? '';
      if (convId.isNotEmpty && currentConversationId.isEmpty) {
        currentConversationId = convId;
      }
      messages.remove(optimistic);
      await loadMessages();
    } catch (_) {
      messages.remove(optimistic);
      messages.refresh();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _messageSubscription?.cancel();
    _userOnlineSubscription?.cancel();
    _userOfflineSubscription?.cancel();
    // Allow the conversation list to show the real unread count again
    try {
      final mc = Get.find<MessageController>();
      if (mc.currentOpenConversationId == currentConversationId) {
        mc.currentOpenConversationId = '';
      }
    } catch (_) {}
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
