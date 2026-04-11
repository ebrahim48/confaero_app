import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:confaero_app/presentations/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../controllers/message_controller.dart';
import '../message_item_widget.dart';


class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.people_outline, size: 24.r),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: 'Event Participant',
                            fontsize: 18 ,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor252525,
                             ),
                          CustomText(
                            text: 'Connect with everyone',
                            fontsize: 14 ,
                            fontWeight: FontWeight.w600,

                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  /// Search
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by participant',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Message List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshConversations(),
                color: const Color(0xff32A69A),
                child: Obx(
                      () {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff32A69A),
                        ),
                      );
                    }
                    
                    if (controller.messages.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      return MessageItemWidget(
                        message: msg,
                        onTap: () {
                          controller.markAsRead(msg.id);
                          context.pushNamed(
                            AppRoutes.messageChatScreen,
                            extra: {
                              'conversationId': msg.id,
                              'receiverId': msg.id,
                            },
                          );
                        },
                      );
                    },
                  );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80.sp,
              color: const Color(0xFFAD9D8D),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Conversations Yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF252525),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start connecting with other attendees. Your conversations will appear here once you message someone.',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to attendee home to browse attendees
                Get.toNamed(AppRoutes.attendeeHomeScreen);
              },
              icon: Icon(Icons.people_alt_outlined, size: 20.sp),
              label: Text(
                'Browse Attendees',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF32A69A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Tap "Say Hi" on any attendee profile to start messaging',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
