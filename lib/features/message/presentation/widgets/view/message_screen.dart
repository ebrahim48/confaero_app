import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/message_controller.dart';
import '../message_item_widget.dart';
import 'message_chat_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Messages',
                    fontsize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor252525,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: 'Your conversations',
                    fontsize: 13.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                  SizedBox(height: 16.h),

                  // Search
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchMessages,
                      decoration: InputDecoration(
                        hintText: 'Search conversations',
                        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                        prefixIcon: Icon(Icons.search, size: 20.sp, color: AppColors.textColor7E7F7E),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),

            // List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return const _ConversationShimmer();

                return RefreshIndicator(
                  onRefresh: controller.refreshConversations,
                  color: const Color(0xff32A69A),
                  child: controller.filteredMessages.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          itemCount: controller.filteredMessages.length,
                          itemBuilder: (context, index) {
                            final msg = controller.filteredMessages[index];
                            return MessageItemWidget(
                              message: msg,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MessageChatScreen(
                                      conversationId: msg.id,
                                      receiverId: msg.participantId,
                                      receiverName: msg.name,
                                      receiverImage: msg.avatarUrl,
                                      receiverLastSeen: msg.lastSeen,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 72.sp, color: const Color(0xFFBDBDBD)),
            SizedBox(height: 16.h),
            Text(
              'No Conversations Yet',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: const Color(0xFF252525)),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tap "Say Hi" on any attendee profile to start messaging.',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF757575)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationShimmer extends StatelessWidget {
  const _ConversationShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              CircleAvatar(radius: 24.r, backgroundColor: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14.h, width: 120.w, color: Colors.white),
                    SizedBox(height: 8.h),
                    Container(height: 12.h, width: 200.w, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
