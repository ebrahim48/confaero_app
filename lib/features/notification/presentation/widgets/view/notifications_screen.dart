import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controller/notifications_controller.dart';
import '../notifications_widgets.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Notifications',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xffFEFEFE),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: const Color(0xffD2D2D2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Search Icon
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ),

                  // Search TextField
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchNotifications,
                      decoration: InputDecoration(
                        hintText: 'Search your notification',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor424242,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications List
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredNotifications.isEmpty
                  ? Center(
                child: CustomText(
                  text: 'No notifications',
                  fontsize: 14.sp,
                  color: AppColors.textColor7E7F7E,
                ),
              )
                  : RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                    controller.filteredNotifications[index];
                    return NotificationItemWidget(
                      notification: notification,
                      onTap: () {
                        controller.markAsRead(notification.id);
                        print('Notification tapped: ${notification.id}');
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}