import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/organizer_messaging_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class OrganizerChatScreen extends StatelessWidget {
  const OrganizerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrganizerMessagingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Chat'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg =
                      controller.messages[controller.messages.length -
                          1 -
                          index];
                  final isMe = msg['isMe'] as bool? ?? false;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      constraints: BoxConstraints(maxWidth: 260.w),
                      decoration: BoxDecoration(
                        color:
                            isMe
                                ? const Color(0xff32A69A)
                                : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        msg['content'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isMe ? Colors.white : const Color(0xFF252525),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Message input bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: const Color(0xFFE0E0E0))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageCtrl,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => GestureDetector(
                      onTap:
                          controller.isSending.value
                              ? null
                              : controller.sendMessage,
                      child: CircleAvatar(
                        radius: 22.r,
                        backgroundColor: const Color(0xff32A69A),
                        child: Icon(
                          controller.isSending.value
                              ? Icons.hourglass_bottom
                              : Icons.send,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
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
}
