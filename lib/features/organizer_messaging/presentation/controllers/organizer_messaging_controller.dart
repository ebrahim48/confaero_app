import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/organizer_message_service.dart';

class OrganizerMessagingController extends GetxController {
  final OrganizerMessageService _service = Get.find<OrganizerMessageService>();

  final conversations = <Map<String, dynamic>>[].obs;
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  final messageCtrl = TextEditingController();

  String currentEventId = '';
  String currentConversationId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadConversations();
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final response = await _service.getConversations(currentEventId);
      if (response['data'] is List) {
        conversations.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(String conversationId) async {
    currentConversationId = conversationId;
    try {
      isLoading.value = true;
      final response = await _service.getMessages(
        conversationId,
        currentEventId,
      );
      if (response['data'] is List) {
        messages.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    if (messageCtrl.text.trim().isEmpty) return;
    try {
      isSending.value = true;
      await _service.sendMessage(currentEventId, {
        'conversationId': currentConversationId,
        'content': messageCtrl.text,
      });
      messageCtrl.clear();
      loadMessages(currentConversationId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  // ======================== Additional Methods ========================

  final notifications = <Map<String, dynamic>>[].obs;

  Future<Map<String, dynamic>?> getUserPresence(String userId) async {
    try {
      final response = await _service.getUserPresence(userId, currentEventId);
      return response['data'] as Map<String, dynamic>?;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get presence');
      return null;
    }
  }

  Future<void> markAsSeen(String messageId) async {
    try {
      await _service.markAsSeen(messageId, currentEventId);
    } catch (e) {
      // Silent fail — non-critical
    }
  }

  Future<void> loadNotifications() async {
    try {
      final response = await _service.getNotifications(currentEventId);
      if (response['data'] is List) {
        notifications.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    }
  }
}
