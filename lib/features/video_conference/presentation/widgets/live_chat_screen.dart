import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/models/live_session_message.dart';
import '../controllers/event_live_controller.dart';

/// Live session chat screen with real-time messaging via Socket.IO.
class LiveChatScreen extends StatelessWidget {
  final int sessionIndex;

  const LiveChatScreen({super.key, required this.sessionIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventLiveController());
    final socketService = Get.find<SocketService>();

    // Join the session when screen loads
    controller.joinSession(sessionIndex: sessionIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Live Chat'),
        backgroundColor: const Color(0xFF32A69A),
        foregroundColor: Colors.white,
        actions: [
          // Viewer count badge
          Obx(() {
            final count = controller.viewerCount.value;
            if (count > 0) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, size: 14.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          Obx(() {
            if (!socketService.isConnected.value) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, size: 18.sp, color: Colors.orange),
                    SizedBox(width: 8.w),
                    Text(
                      'Connecting to live session...',
                      style: TextStyle(fontSize: 12.sp, color: Colors.orange.shade900),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Messages list
          Expanded(
            child: Obx(() {
              final messages = controller.liveMessages;

              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64.r,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Be the first to say something!',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _MessageBubble(message: message);
                },
              );
            }),
          ),

          // Message input
          _MessageInput(controller: controller),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final LiveSessionMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFF32A69A).withAlpha(51),
            child: Icon(
              Icons.person,
              size: 18.sp,
              color: const Color(0xFF32A69A),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(4.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      'User ${message.userId.substring(0, message.userId.length > 6 ? 6 : message.userId.length)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF32A69A),
                      ),
                    ),
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _MessageInput extends StatelessWidget {
  final EventLiveController controller;
  final TextEditingController _textController = TextEditingController();

  _MessageInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final isConnected = Get.find<SocketService>().isConnected.value;
            return Container(
              decoration: BoxDecoration(
                color: isConnected ? const Color(0xFF32A69A) : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: isConnected ? _sendMessage : null,
                icon: Icon(Icons.send, color: Colors.white, size: 20.sp),
                padding: EdgeInsets.all(10.w),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    controller.messageInput.value = text;
    controller.sendLiveMessage();
    _textController.clear();
  }
}
