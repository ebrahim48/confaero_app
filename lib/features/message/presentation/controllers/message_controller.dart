import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/models/message_model.dart';
import '../../domain/services/message_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class MessageController extends GetxController {
  final MessageService _messageService = Get.find<MessageService>();
  final SocketService _socketService = Get.find<SocketService>();
  final searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<MessageModel> filteredMessages = <MessageModel>[].obs;

  // Socket subscription
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  // Event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadConversations();

    // Refresh conversation list whenever a new message arrives via socket
    _messageSubscription = _socketService.onNewMessage.listen((_) {
      loadConversations();
    });
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      final conversations = await _messageService.getConversations(
        currentEventId,
      );
      messages.value =
          conversations
              .map(
                (conv) => MessageModel(
                  id: conv.id,
                  name: conv.participantName,
                  message: conv.lastMessage?.content ?? '',
                  time:
                      conv.lastMessage != null
                          ? _formatTime(conv.lastMessage!.createdAt)
                          : '',
                  avatarUrl: conv.participantAvatar,
                  hasUnread: conv.unreadCount > 0,
                ),
              )
              .toList();
      filteredMessages.value = messages;
      
      // Show message if no conversations available
      if (messages.isEmpty) {
        ToastMessageHelper.showToastMessage(
          'Messages coming soon. Start a conversation!',
          title: 'Info',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Messages coming soon. Start a conversation!', title: 'Info');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $p';
  }

  void searchMessages(String query) {
    if (query.isEmpty) {
      filteredMessages.value = messages;
    } else {
      filteredMessages.value =
          messages
              .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
  }

  Future<void> markAsRead(String id) async {
    final msg = messages.firstWhere((e) => e.id == id);
    msg.hasUnread = false;
    messages.refresh();
    filteredMessages.refresh();

    // Mark as seen on server
    try {
      await _messageService.markMessageSeen(id, currentEventId);
    } catch (_) {
      // Silent fail — local UI is already updated
    }
  }

  Future<void> refreshConversations() async {
    await loadConversations();
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
