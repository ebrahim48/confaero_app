import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../controllers/organizer_messaging_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class OrganizerConversationsScreen extends StatelessWidget {
  const OrganizerConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrganizerMessagingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Organizer Messages'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.conversations.isEmpty) {
                return Center(
                  child: Text(
                    'No conversations',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadConversations,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.conversations.length,
                  itemBuilder: (context, index) {
                    final conv = controller.conversations[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFD7EAE8)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff32A69A),
                          child: Text(
                            (conv['name'] as String? ?? 'C')[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(conv['name'] as String? ?? 'Conversation'),
                        subtitle: Text(
                          conv['lastMessage'] as String? ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Color(0xff32A69A),
                        ),
                        onTap: () {
                          controller.loadMessages(conv['_id'] as String? ?? '');
                          context.pushNamed(AppRoutes.organizerChatScreen);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
