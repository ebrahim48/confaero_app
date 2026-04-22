import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/message_chat_controller.dart';
import '../../controllers/message_controller.dart';
import '../chat_bubble_widget.dart';

class MessageChatScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;
  final String? receiverImage;
  final String? conversationId;
  final DateTime? receiverLastSeen;
  // Legacy: accept map from GoRouter extra
  final Map<String, dynamic>? args;

  const MessageChatScreen({
    super.key,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
    this.conversationId,
    this.receiverLastSeen,
    this.args,
  });

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  late final MessageChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MessageChatController());

    final receiverId = widget.receiverId ??
        widget.args?['receiverId'] as String? ?? '';
    final receiverName = widget.receiverName ??
        widget.args?['receiverName'] as String? ?? 'User';
    final receiverImage = widget.receiverImage ??
        widget.args?['receiverImage'] as String? ?? '';
    final conversationId = widget.conversationId ??
        widget.args?['conversationId'] as String? ?? '';

    // Populate global participant cache so the conversation list shows names
    if (receiverId.isNotEmpty) {
      MessageController.participantCache[receiverId] = {
        'name': receiverName,
        'avatar': receiverImage,
      };
    }

    controller.init(
      receiverId: receiverId,
      receiverNameVal: receiverName,
      receiverImageVal: receiverImage,
      conversationId: conversationId,
      receiverLastSeen: widget.receiverLastSeen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textColor424242),
                  ),
                  SizedBox(width: 12.w),
                  Obx(() {
                    final imageUrl = controller.receiverImage.value;
                    return CircleAvatar(
                      radius: 20.r,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/sampleprofile.png'),
                    );
                  }),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: controller.receiverName.value,
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor252525,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Container(
                              width: 7.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isReceiverOnline.value
                                    ? const Color(0xff4CAF50)
                                    : Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: controller.isReceiverOnline.value ? 'Online' : 'Offline',
                              fontsize: 11.sp,
                              color: controller.isReceiverOnline.value
                                  ? const Color(0xff4CAF50)
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return _buildShimmer();
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64.sp, color: const Color(0xffBDBDBD)),
                        SizedBox(height: 12.h),
                        CustomText(
                          text: 'Say Hi to start the conversation!',
                          fontsize: 14.sp,
                          color: AppColors.textColor7E7F7E,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final showDate = index == 0 ||
                        controller.messages[index].date !=
                            controller.messages[index - 1].date;
                    return Column(
                      children: [
                        if (showDate)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              msg.date,
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                            ),
                          ),
                        ChatBubbleWidget(
                          message: msg.text,
                          isMe: msg.isMe,
                          time: msg.time,
                          attachmentUrl: msg.attachmentUrl,
                          attachmentName: msg.attachmentName,
                          mimeType: msg.mimeType,
                        ),
                        SizedBox(height: 6.h),
                      ],
                    );
                  },
                );
              }),
            ),

            // Input bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 47.h),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              maxLines: 4,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textColor7E7F7E),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                              ),
                              style: TextStyle(fontSize: 14.sp, color: Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.pickAndSendAttachment,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
                              child: SvgPicture.asset('assets/icons/share2.svg', width: 19.w, height: 19.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Obx(() {
                    final hasText = controller.messageText.value.trim().isNotEmpty;
                    return GestureDetector(
                      onTap: hasText ? controller.sendMessage : null,
                      child: Container(
                        width: 47.w,
                        height: 47.h,
                        decoration: BoxDecoration(
                          color: hasText ? const Color(0xFF32A69A) : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: controller.isSending.value
                            ? Padding(
                                padding: EdgeInsets.all(14.w),
                                child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2),
                              )
                            : const Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: 8,
        itemBuilder: (_, i) => Align(
          alignment: i % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            width: (i % 3 + 2) * 60.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
