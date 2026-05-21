import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
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
            _buildHeader(),
            Expanded(child: _buildBody(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: AppColors.primaryColor32A69A,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252525),
                ),
              ),
              Text(
                'Organizer announcements',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF7E7F7E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CommunityController controller) {
    return Obx(() {
      if (controller.isLoading.value) return _buildShimmer();

      if (controller.announcements.isEmpty) return _buildEmptyState();

      return RefreshIndicator(
        onRefresh: controller.refreshAnnouncements,
        color: AppColors.primaryColor32A69A,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: controller.announcements.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, __) => Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 13.h,
                        width: 180.w,
                        color: Colors.white),
                    SizedBox(height: 8.h),
                    Container(
                        height: 11.h,
                        width: double.infinity,
                        color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(
                        height: 11.h,
                        width: 120.w,
                        color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_rounded,
              size: 40.r,
              color: AppColors.primaryColor32A69A,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No announcements yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF252525),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Check back later for updates',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF7E7F7E),
            ),
          ),
        ],
      ),
    );
  }
}
