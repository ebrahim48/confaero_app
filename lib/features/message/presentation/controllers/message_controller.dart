import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/models/message_model.dart';

class MessageController extends GetxController {
  final searchController = TextEditingController();

  RxList<MessageModel> messages = <MessageModel>[
    MessageModel(
      id: '1',
      name: 'Jane Cooper',
      message: 'Hello how are you?',
      time: '4:30 PM',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      hasUnread: true,
    ),
    MessageModel(
      id: '2',
      name: 'Wade Warren',
      message: 'Let’s meet at the event',
      time: '1:30 PM',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      hasUnread: true,
    ),
    MessageModel(
      id: '3',
      name: 'Albert Flores',
      message: 'See you soon!',
      time: 'Yesterday',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
  ].obs;

  void markAsRead(String id) {
    final msg = messages.firstWhere((e) => e.id == id);
    msg.hasUnread = false;
    messages.refresh();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
