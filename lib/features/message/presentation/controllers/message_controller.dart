import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/models/message_model.dart';
import '../../domain/services/message_service.dart';

class MessageController extends GetxController {
  final MessageService _messageService = Get.find<MessageService>();
  final SocketService _socketService = Get.find<SocketService>();
  final searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxList<MessageModel> filteredMessages = <MessageModel>[].obs;

  /// Set this to the conversationId that is currently open so
  /// loadConversations() doesn't restore the unread badge for it.
  String currentOpenConversationId = '';

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  String get currentEventId => SessionController.to.eventId;
  String _currentUserId = '';

  // Cache participant info keyed by participantId, populated when chats are opened.
  // This persists for the lifetime of the controller so the conversation list
  // shows correct names/avatars on reload.
  static final Map<String, Map<String, String>> participantCache = {};

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    _messageSubscription = _socketService.onNewMessage.listen((_) {
      loadConversations();
    });
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      _currentUserId = await PrefsHelper.getString(AppConstants.userId);

      final conversations = await _messageService.getConversations(currentEventId);

      messages.value = conversations.map((conv) {
        final isCurrentlyOpen = conv.id == currentOpenConversationId;
        return MessageModel(
          id: conv.id,
          participantId: conv.participantId,
          name: conv.participantName,
          message: conv.lastMessageText,
          time: conv.lastMessageAt != null ? _formatTime(conv.lastMessageAt!) : '',
          avatarUrl: conv.participantAvatar,
          hasUnread: isCurrentlyOpen ? false : conv.unreadCount > 0,
          unreadCount: isCurrentlyOpen ? 0 : conv.unreadCount,
          lastSeen: conv.participantLastSeen,
        );
      }).toList();

      filteredMessages.value = messages;
    } catch (_) {
      messages.clear();
      filteredMessages.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshConversations() async => loadConversations();

  /// Immediately clears the unread badge for a conversation in the UI
  /// before the backend confirms (optimistic update).
  void clearUnreadForConversation(String conversationId) {
    final idx = messages.indexWhere((m) => m.id == conversationId);
    if (idx == -1) return;
    final m = messages[idx];
    messages[idx] = MessageModel(
      id: m.id,
      participantId: m.participantId,
      name: m.name,
      message: m.message,
      time: m.time,
      avatarUrl: m.avatarUrl,
      hasUnread: false,
      unreadCount: 0,
      lastSeen: m.lastSeen,
    );
    filteredMessages.value = List.from(messages);
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }
    return '${dt.day}/${dt.month}';
  }

  void searchMessages(String query) {
    if (query.isEmpty) {
      filteredMessages.value = messages;
    } else {
      filteredMessages.value = messages
          .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
