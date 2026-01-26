import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/community_controller.dart';
import '../announcement_card.dart';


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Announcement List
            Expanded(
              child: _buildAnnouncementList(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Text(
          'Community',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementList(CommunityController controller) {
    return Obx(() {
      // // Loading State
      // if (controller.isLoading.value) {
      //   return const Center(
      //     child: CircularProgressIndicator(
      //       color: Color(0xFF4CAF50),
      //     ),
      //   );
      // }

      // Empty State
      if (controller.announcements.isEmpty) {
        return _buildEmptyState();
      }

      // Data State
      return RefreshIndicator(
        onRefresh: controller.refreshAnnouncements,
        color: const Color(0xFF4CAF50),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: controller.announcements.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final announcement = controller.announcements[index];
            return AnnouncementCard(
              announcement: announcement,
              onTap: () => controller.onAnnouncementTap(context),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No announcements yet',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for updates',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}