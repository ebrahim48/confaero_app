import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/services/message_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String date;
  final bool showTime;
  final String? attachmentUrl;
  final String? attachmentName;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.date,
    this.showTime = true,
    this.attachmentUrl,
    this.attachmentName,
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
  }

  /// Called by the screen in initState with all required params.
  Future<void> init({
    required String receiverId,
    String receiverNameVal = 'User',
    String receiverImageVal = '',
    String conversationId = '',
  }) async {
    currentReceiverId = receiverId;
    receiverName.value = receiverNameVal;
    receiverImage.value = receiverImageVal;
    currentConversationId = conversationId;
    _currentUserId = await PrefsHelper.getString(AppConstants.userId);

    // Track online status of receiver
    isReceiverOnline.value = _socketService.isUserOnline(receiverId);

    if (conversationId.isNotEmpty) {
      _socketService.emitJoinConversation(conversationId: conversationId);
      await loadMessages();
    }
  }

  Future<void> loadMessages() async {
    if (currentConversationId.isEmpty) return;
    isLoading.value = true;
    try {
      final data = await _messageService.getMessages(
        currentConversationId,
        currentEventId,
      );
      messages.value = data.map((m) {
        final isMe = _currentUserId.isNotEmpty
            ? m.senderId == _currentUserId
            : m.isMe;
        final att = m.attachments.isNotEmpty ? m.attachments.first : null;
        return ChatMessage(
          text: att != null ? '📎 ${att['name'] ?? 'Attachment'}' : m.text,
          isMe: isMe,
          time: _formatTime(m.createdAt),
          date: _formatDate(m.createdAt),
          showTime: true,
          attachmentUrl: att?['url']?.toString(),
          attachmentName: att?['name']?.toString(),
        );
      }).toList();

      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load messages', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleSocketMessage(Map<String, dynamic> data) {
    // Ignore typing/seen meta-events mixed into the same stream
    if (data['isTyping'] != null || data['isSeen'] != null) return;

    final msgConvId = data['conversationId']?.toString() ?? '';
    // If we know our conversationId, only accept messages for it
    if (currentConversationId.isNotEmpty &&
        msgConvId.isNotEmpty &&
        msgConvId != currentConversationId) return;

    // Once we get the first message, we know the conversationId
    if (currentConversationId.isEmpty && msgConvId.isNotEmpty) {
      currentConversationId = msgConvId;
      _socketService.emitJoinConversation(conversationId: msgConvId);
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
        _socketService.emitJoinConversation(conversationId: convId);
      }
    } catch (_) {
      messages.remove(optimistic);
      messages.refresh();
      ToastMessageHelper.showToastMessage('Failed to send message', title: 'Error');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> pickAndSendAttachment() async {
    try {
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

      await _messageService.sendMessage(
        currentEventId,
        receiverId: currentReceiverId,
        content: fileName,
        attachmentFile: file,
      );
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to send attachment', title: 'Error');
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
    if (currentConversationId.isNotEmpty) {
      _socketService.emitLeaveConversation(conversationId: currentConversationId);
    }
    _messageSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
