import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Observable for button state
  final RxString messageText = ''.obs;

  final messages = <ChatMessage>[
    ChatMessage(
      text: "Hi, I'm looking to get my backyard pool cleaned. Do you offer that service?",
      isMe: false,
      time: "9:00 PM",
      date: "Yesterday, 9:00 PM",
    ),
    ChatMessage(
      text: "Yes, we do! Can you tell me the size and condition of your pool?",
      isMe: true,
      time: "9:00 PM",
      date: "Today, 9:00 PM",
    ),
    ChatMessage(
      text: "It's medium-sized, 15×30 feet. Haven't cleaned it in months, so there's algae and leaves.",
      isMe: false,
      time: "9:01 PM",
      date: "Today, 9:00 PM",
    ),
    ChatMessage(
      text: "Got it. We recommend a thorough cleaning. When would you like us to come by?",
      isMe: true,
      time: "9:02 PM",
      date: "Today, 9:00 PM",
    ),
    ChatMessage(
      text: "Is Saturday morning possible?",
      isMe: false,
      time: "9:03 PM",
      date: "Today, 9:00 PM",
    ),
    ChatMessage(
      text: "Let me check... Yes, we have a spot at 10 AM. Does that work?",
      isMe: true,
      time: "8:39 AM",
      date: "Today, 9:00 PM",
      showTime: true,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes
    messageController.addListener(() {
      messageText.value = messageController.text;
    });

    // Auto scroll to bottom when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      text: messageController.text.trim(),
      isMe: true,
      time: _getCurrentTime(),
      date: "Today, 9:00 PM",
      showTime: true,
    );

    messages.add(newMessage);
    messageController.clear();
    messageText.value = '';

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });
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