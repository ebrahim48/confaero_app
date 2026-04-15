import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

/// Controller for organizer messaging.
/// NOTE: messageOrganizer endpoints have been removed from backend API.
/// This controller is kept as a stub for future use.
class OrganizerMessagingController extends GetxController {
  final conversations = <Map<String, dynamic>>[].obs;
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final notifications = <Map<String, dynamic>>[].obs;

  final messageCtrl = TextEditingController();

  String currentEventId = '';
  String currentConversationId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }

  Future<void> loadConversations() async {
    // REMOVED: messageOrganizer endpoints no longer in backend API
    ToastMessageHelper.showToastMessage(
      'Organizer messaging not available',
      title: 'Info',
    );
  }

  Future<void> loadMessages(String conversationId) async {
    // REMOVED
  }

  Future<void> sendMessage() async {
    // REMOVED
  }
}
