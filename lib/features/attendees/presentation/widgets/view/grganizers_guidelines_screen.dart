import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/organizer_guidelines_controller.dart';


class OrganizserGuidelinesScreen extends StatelessWidget {
  const OrganizserGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrganizerGuidelinesController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // ── App Bar ──────────────────────────────────────────────
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
                    child: Obx(() => CustomText(
                          text: controller.title.value.isNotEmpty
                              ? controller.title.value
                              : 'Organizer Guidelines',
                          fontsize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor424242,
                          maxline: 1,
                        )),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              // Loading
              if (controller.isLoading.value) {
                return _buildShimmer();
              }

              // Error
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
                        CustomText(
                          text: controller.errorMessage.value,
                          fontsize: 14.sp,
                          color: AppColors.textColor7E7F7E,
                          textAlign: TextAlign.center,
                          maxline: 3,
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
                            child: CustomText(
                              text: 'Retry',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Empty
              if (controller.content.value.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No content available.',
                    fontsize: 14.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                );
              }

              // Content
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
                      // Static banner image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          'assets/images/myevents.png',
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Dynamic HTML content from API
                      Html(
                        data: controller.content.value,
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
                          'ul': Style(
                            margin: Margins.only(left: 16, bottom: 12),
                          ),
                          'ol': Style(
                            margin: Margins.only(left: 16, bottom: 12),
                          ),
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
                      ),

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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xffE0E0E0),
      highlightColor: const Color(0xffF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner shimmer
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 20.h),
            // Text lines shimmer
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
