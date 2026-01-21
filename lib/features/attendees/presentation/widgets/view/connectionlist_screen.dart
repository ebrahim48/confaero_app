import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/connectionlist_controller.dart';
import '../connection_card_widget.dart';

class ConnectionListScreen extends StatelessWidget {
  const ConnectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConnectionListController());

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
                      text: 'Connection List',
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
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xffFEFEFE),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: const Color(0xffE1E1E1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchConnections,
                      decoration: InputDecoration(
                        hintText: 'Search people in your list',
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

          // Stats Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(
                  () => Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: '${controller.totalConnections.value}',
                            fontsize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: 'Total Connection',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor252525,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: '${controller.bookmarkedCount.value}',
                            fontsize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: 'Bookmarked',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor252525,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Connections List
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: controller.refreshConnections,
                child: controller.filteredConnections.isEmpty
                    ? Center(
                  child: CustomText(
                    text: 'No connections found',
                    fontsize: 14.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.filteredConnections.length,
                  itemBuilder: (context, index) {
                    final connection =
                    controller.filteredConnections[index];
                    return ConnectionCardWidget(
                      connection: connection,
                      onBookmarkTap: () =>
                          controller.toggleBookmark(connection.id),
                      onSayHi: () => controller.sayHi(connection.id),
                      onSendMail: () =>
                          controller.sendMail(connection.id),
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