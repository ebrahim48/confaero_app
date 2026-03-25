import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/message_service.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String date;
  final bool showTime;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.date,
    this.showTime = false,
  });
}

class MessageChatController extends GetxController {
  final MessageService _messageService = Get.find<MessageService>();

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Observable for button state
  final RxString messageText = ''.obs;

  final messages = <ChatMessage>[].obs;

  // Example conversational constants
  // Event ID from global session state; conversationId + receiverId from route args
  String get currentEventId => SessionController.to.eventId;
  String currentReceiverId = '';
  String currentConversationId = '';

  Future<void> loadMessages() async {
    try {
      final messageData = await _messageService.getMessages(
        currentConversationId,
        currentEventId,
      );
      messages.value =
          messageData
              .map(
                (m) => ChatMessage(
                  text: m.content,
                  isMe:
                      m.isMe, // Assuming MessageModel has senderId to evaluate
                  time: _formatMessageTime(m.createdAt),
                  date: _formatMessageDate(m.createdAt),
                ),
              )
              .toList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load messages',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _formatMessageTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $p';
  }

  String _formatMessageDate(DateTime dt) {
    return 'Today'; // Minimal generic format for demo
  }

  @override
  void onInit() {
    super.onInit();

    // Read conversationId and receiverId from navigation args
    // Navigator must pass: { 'conversationId': '...', 'receiverId': '...' }
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    currentConversationId = args['conversationId'] as String? ?? '';
    currentReceiverId = args['receiverId'] as String? ?? '';

    messageController.addListener(() {
      messageText.value = messageController.text;
    });

    if (currentConversationId.isNotEmpty) {
      loadMessages();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      text: text,
      isMe: true,
      time: _getCurrentTime(),
      date: "Today",
      showTime: true,
    );

    messages.add(newMessage);
    messageController.clear();
    messageText.value = '';

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });

    try {
      await _messageService.sendMessage(
        currentEventId,
        receiverId: currentReceiverId,
        content: text,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message over network',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Could visually indicate unsent text here
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

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
