import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../chat_bubble_widget.dart';
import '../../controllers/message_chat_controller.dart';

class MessageChatScreen extends StatelessWidget {
  final Map<String, dynamic>? args;
  const MessageChatScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageChatController());
    // If args were passed via GoRouter extra, inject them before onInit reads
    if (args != null && controller.currentConversationId.isEmpty) {
      controller.currentConversationId = args!['conversationId'] as String? ?? '';
      controller.currentReceiverId = args!['receiverId'] as String? ?? '';
      if (controller.currentConversationId.isNotEmpty) {
        controller.loadMessages();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  const BackButton(),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.attendeeDetailsScreen);
                    },
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundImage:
                      const NetworkImage("https://i.pravatar.cc/150?img=3"),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Wade Warren',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: 'Active 1h ago',
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor7E7F7E,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert)
                ],
              ),
            ),

            /// 🔹 Messages
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];

                    bool showDateLabel = false;
                    if (index == 0) {
                      showDateLabel = true;
                    } else if (controller.messages[index].date !=
                        controller.messages[index - 1].date) {
                      showDateLabel = true;
                    }

                    return Column(
                      children: [
                        if (showDateLabel) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              message.date,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                        ChatBubbleWidget(
                          message: message.text,
                          isMe: message.isMe,
                          time: message.showTime ? message.time : null,
                        ),
                        SizedBox(height: 6.h),
                      ],
                    );
                  },
                ),
              ),
            ),

            /// 🔹 Input Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                children: [
                  /// Text Field
                  Expanded(
                    child: Container(
                      height: 47.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14.sp),
                              ),
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  controller.sendMessage();
                                }
                              },
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/icons/share2.svg",
                            width: 19.w,
                            height: 19.h,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  /// Send Button
                  Obx(
                        () => GestureDetector(
                      onTap: controller.messageText.value.trim().isEmpty
                          ? null
                          : controller.sendMessage,
                      child: Container(
                        width: 47.w,
                        height: 47.h,
                        decoration: BoxDecoration(
                          color: controller.messageText.value.trim().isEmpty
                              ? Colors.grey.shade300
                              : const Color(0xFF73AAA6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}