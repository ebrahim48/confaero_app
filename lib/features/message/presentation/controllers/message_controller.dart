import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../domain/models/message_model.dart';
import '../../domain/services/message_service.dart';

class MessageController extends GetxController {
  final MessageService _messageService = Get.find<MessageService>();
  final searchController = TextEditingController();

  final RxBool isLoading = false.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<MessageModel> filteredMessages = <MessageModel>[].obs;

  // Event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load conversations',
        snackPosition: SnackPosition.BOTTOM,
      );
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

  void markAsRead(String id) {
    final msg = messages.firstWhere((e) => e.id == id);
    msg.hasUnread = false;
    messages.refresh();
    filteredMessages.refresh();
  }

  Future<void> refreshConversations() async {
    await loadConversations();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
