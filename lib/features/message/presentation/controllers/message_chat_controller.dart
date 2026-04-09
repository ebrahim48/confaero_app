import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/services/message_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

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
  final SocketService _socketService = Get.find<SocketService>();

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Observable for button state
  final RxString messageText = ''.obs;

  final messages = <ChatMessage>[].obs;

  // Socket subscription
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

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
      ToastMessageHelper.showToastMessage('Failed to load messages', title: 'Error');
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
      // Join the conversation room for real-time updates
      _socketService.emitJoinConversation(conversationId: currentConversationId);
    }

    // Listen for real-time incoming messages via Socket.IO
    _messageSubscription = _socketService.onNewMessage.listen(_handleSocketMessage);
  }

  /// Handle a real-time message from Socket.IO.
  void _handleSocketMessage(Map<String, dynamic> data) {
    // Only add if it belongs to the current conversation
    final msgConversationId = data['conversationId']?.toString() ?? '';
    if (msgConversationId != currentConversationId && msgConversationId.isNotEmpty) {
      return; // Not for this chat
    }

    // Ignore messages sent by the current user (already shown optimistically)
    final senderId = data['senderId']?.toString() ?? '';
    if (senderId == currentReceiverId || senderId.isEmpty) {
      // It's from the other person → show it
      final content = data['content']?.toString() ?? '';
      if (content.isEmpty) return;

      messages.add(ChatMessage(
        text: content,
        isMe: false,
        time: _getCurrentTime(),
        date: 'Today',
        showTime: true,
      ));

      Future.delayed(const Duration(milliseconds: 100), () => scrollToBottom());
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

    // Try sending via Socket.IO first for real-time delivery
    final socketSent = await _socketService.emitMessage(
      conversationId: currentConversationId,
      receiverId: currentReceiverId,
      content: text,
      eventId: currentEventId,
    );

    // If Socket.IO fails, fallback to REST API
    if (!socketSent) {
      try {
        await _messageService.sendMessage(
          currentEventId,
          receiverId: currentReceiverId,
          content: text,
        );
      } catch (e) {
        ToastMessageHelper.showToastMessage(
          'Failed to send message',
          title: 'Error',
        );
        // Remove the optimistic message on failure
        messages.removeWhere((m) => m.text == text && m.isMe);
      }
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

  /// Pick a file and send it as an attachment
  Future<void> pickAndSendAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        // Show optimistic message
        final newMessage = ChatMessage(
          text: '📎 $fileName',
          isMe: true,
          time: _getCurrentTime(),
          date: "Today",
          showTime: true,
        );
        messages.add(newMessage);
        Future.delayed(const Duration(milliseconds: 100), () => scrollToBottom());

        await _messageService.sendMessage(
          currentEventId,
          receiverId: currentReceiverId,
          content: fileName,
          attachmentFile: file,
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to send attachment', title: 'Error');
    }
  }

  @override
  void onClose() {
    // Leave the conversation room
    if (currentConversationId.isNotEmpty) {
      _socketService.emitLeaveConversation(conversationId: currentConversationId);
    }
    _messageSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
