import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/connectionlist_controller.dart';
import 'connection_details_screen.dart';

class ConnectionListScreen extends StatelessWidget {
  const ConnectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConnectionListController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                    child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textColor424242),
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

          // Search bar
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xffE1E1E1)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(Icons.search, size: 20.sp, color: AppColors.textColor7E7F7E),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchConnections,
                      decoration: InputDecoration(
                        hintText: 'Search connections',
                        hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textColor424242),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() => Row(
              children: [
                Expanded(child: _statCard('${controller.totalConnections.value}', 'Total Connections')),
                SizedBox(width: 12.w),
                Expanded(child: _statCard('${controller.bookmarkedCount.value}', 'Bookmarked')),
              ],
            )),
          ),

          SizedBox(height: 16.h),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const _ConnectionShimmer();
              return RefreshIndicator(
                onRefresh: controller.refreshConnections,
                color: const Color(0xff32A69A),
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
                          final c = controller.filteredConnections[index];
                          return _ConnectionCard(
                            connection: c,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConnectionDetailsScreen(connectionId: c.id),
                              ),
                            ),
                            onBookmark: () => controller.toggleBookmark(c.id),
                            onSayHi: () => controller.sayHi(c),
                            onMail: () => controller.sendMail(c.email),
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

  Widget _statCard(String count, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xffE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: count, fontsize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.textColor424242),
            SizedBox(height: 4.h),
            CustomText(text: label, fontsize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textColor7E7F7E),
          ],
        ),
      );
}

// ── Connection Card ───────────────────────────────────────────────────────────

class _ConnectionCard extends StatelessWidget {
  final dynamic connection;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onSayHi;
  final VoidCallback onMail;

  const _ConnectionCard({
    required this.connection,
    required this.onTap,
    required this.onBookmark,
    required this.onSayHi,
    required this.onMail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffE0E0E0)),
                  ),
                  child: ClipOval(
                    child: connection.avatarUrl.startsWith('http')
                        ? Image.network(
                            connection.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                SizedBox(width: 12.w),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: connection.name,
                        fontsize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor424242,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: connection.company.isNotEmpty ? connection.company : connection.role,
                        fontsize: 12.sp,
                        color: AppColors.textColor7E7F7E,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                // Bookmark
                GestureDetector(
                  onTap: onBookmark,
                  child: Icon(
                    connection.isBookmarked ? Icons.star : Icons.star_border,
                    size: 22.sp,
                    color: connection.isBookmarked ? const Color(0xffFFD700) : AppColors.textColor7E7F7E,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1, color: const Color(0xffE0E0E0)),
            SizedBox(height: 10.h),
            Row(
              children: [
                _badge(connection.role),
                SizedBox(width: 8.w),
                _badge('${connection.sessionsCount} Sessions'),
                const Spacer(),
                _actionBtn(Icons.chat_bubble_outline, 'Say Hi', const Color(0xffD7EAE8), const Color(0xff32A69A), onSayHi),
                SizedBox(width: 8.w),
                _actionBtn(Icons.mail_outline, 'Mail', const Color(0xffF5F5F5), AppColors.textColor424242, onMail),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey[200],
        child: Icon(Icons.person, size: 24.sp, color: Colors.grey[500]),
      );

  Widget _badge(String text) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(10.r)),
        child: CustomText(text: text, fontsize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textColor7E7F7E),
      );

  Widget _actionBtn(IconData icon, String label, Color bg, Color fg, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            children: [
              Icon(icon, size: 13.sp, color: fg),
              SizedBox(width: 4.w),
              CustomText(text: label, fontsize: 11.sp, fontWeight: FontWeight.w500, color: fg),
            ],
          ),
        ),
      );
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ConnectionShimmer extends StatelessWidget {
  const _ConnectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 100.h,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
    );
  }
}
