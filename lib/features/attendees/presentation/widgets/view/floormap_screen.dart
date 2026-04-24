import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/floormap_controller.dart';
import '../../widgets/view_map_button_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../location_list_item.dart';

class FloorMapScreen extends StatefulWidget {
  const FloorMapScreen({super.key});

  @override
  State<FloorMapScreen> createState() => _FloorMapScreenState();
}

class _FloorMapScreenState extends State<FloorMapScreen>
    with SingleTickerProviderStateMixin {
  FloorMapController get controller => Get.find<FloorMapController>();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<FloorMapController>()) {
      Get.put(FloorMapController(eventId: SessionController.to.eventId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.arrow_back,
                            size: 24.sp, color: AppColors.textColor424242),
                      ),
                      SizedBox(width: 16.w),
                      CustomText(
                        text: 'Floormap',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor424242,
                      ),
                    ],
                  ),
                  Icon(Icons.search,
                      size: 24.sp, color: AppColors.textColor424242),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              // Loading
              if (controller.isLoading.value) {
                return _buildShimmer();
              }

              // Error
              if (controller.errorMessage.isNotEmpty) {
                return _buildError();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // View Map Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ViewMapButton(
                        onTap: () => controller.openMap(context),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Floor map list — dynamic
                    if (controller.floorMaps.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60.h),
                          child: CustomText(
                            text: 'No floor maps available',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor7E7F7E,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.floorMaps.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          color: Color(0xffE0E0E0),
                        ),
                        itemBuilder: (context, index) {
                          final map = controller.floorMaps[index];
                          return LocationListItem(
                            title: map.title,
                            onTap: () =>
                                controller.navigateToLocation(context, index),
                          );
                        },
                      ),
                  ],
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
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ...List.generate(
            5,
                (i) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    children: [
                      Container(
                          width: 200.w,
                          height: 16.h,
                          color: Colors.white),
                      const Spacer(),
                      Container(
                          width: 24.w,
                          height: 24.h,
                          color: Colors.white),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xffE0E0E0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 12.h),
          CustomText(
            text: controller.errorMessage.value,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: controller.loadFloorMaps,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xff5BB8AE),
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
    );
  }
}