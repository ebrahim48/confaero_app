import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../attendees/presentation/controllers/app_content_controller.dart';

class OrganizerAnnouncementsScreen extends StatelessWidget {
  const OrganizerAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AppContentController(
        contentType: 'ORGANIZER_GUIDELINE',
        defaultTitle: 'Organizer Announcements',
      ),
      tag: 'ORGANIZER_GUIDELINE',
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // App Bar
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
                    child: Obx(() => Text(
                          controller.title.value.isNotEmpty
                              ? controller.title.value
                              : 'Organizer Announcements',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                ],
              ),
            ),
          ),

          // Body
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return _buildShimmer();

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48.sp, color: Colors.red.shade300),
                        SizedBox(height: 16.h),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textColor7E7F7E),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: controller.loadContent,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 28.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor32A69A,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.content.value.isEmpty) {
                return Center(
                  child: Text(
                    'No content available.',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.textColor7E7F7E),
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primaryColor32A69A,
                onRefresh: controller.loadContent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner image from API
                      _buildBannerImage(controller.imageUrl.value),
                      SizedBox(height: 20.h),

                      // Dynamic HTML content
                      _buildHtmlContent(controller.content.value),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerImage(String url) {
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: url,
          width: double.infinity,
          height: 200.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: double.infinity,
            height: 200.h,
            color: const Color(0xffF0F0F0),
            child: Center(
              child: CircularProgressIndicator(
                  color: AppColors.primaryColor32A69A),
            ),
          ),
          errorWidget: (_, __, ___) => _assetBanner(),
        ),
      );
    }
    return _assetBanner();
  }

  Widget _assetBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(
        'assets/images/myevents.png',
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHtmlContent(String html) {
    return Html(
      data: html,
      style: {
        'body': Style(
          fontSize: FontSize(14.sp),
          color: AppColors.textColor252525,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(
          fontSize: FontSize(14.sp),
          color: AppColors.textColor252525,
          lineHeight: LineHeight(1.6),
          margin: Margins.only(bottom: 12),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
          color: AppColors.textColor252525,
        ),
        'h1': Style(
          fontSize: FontSize(20.sp),
          fontWeight: FontWeight.w700,
          color: AppColors.textColor252525,
          margin: Margins.only(bottom: 8, top: 16),
        ),
        'h2': Style(
          fontSize: FontSize(18.sp),
          fontWeight: FontWeight.w700,
          color: AppColors.textColor252525,
          margin: Margins.only(bottom: 8, top: 16),
        ),
        'h3': Style(
          fontSize: FontSize(16.sp),
          fontWeight: FontWeight.w600,
          color: AppColors.textColor252525,
          margin: Margins.only(bottom: 6, top: 12),
        ),
        'ul': Style(margin: Margins.only(left: 16, bottom: 12)),
        'ol': Style(margin: Margins.only(left: 16, bottom: 12)),
        'li': Style(
          fontSize: FontSize(14.sp),
          color: AppColors.textColor252525,
          lineHeight: LineHeight(1.6),
        ),
        'a': Style(
          color: AppColors.primaryColor32A69A,
          textDecoration: TextDecoration.underline,
        ),
        'span': Style(
          color: AppColors.textColor252525,
          fontSize: FontSize(14.sp),
        ),
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xffE0E0E0),
      highlightColor: const Color(0xffF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 20.h),
            ...List.generate(
              8,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  width: i % 3 == 0 ? 200.w : double.infinity,
                  height: i % 3 == 0 ? 18.h : 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
