import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/floormap_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';

class FloorMapDetailsScreen extends StatelessWidget {
  const FloorMapDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FloorMapController>();

    return Scaffold(
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
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
                            size: 24.sp,
                            color: AppColors.textColor424242),
                      ),
                      SizedBox(width: 16.w),
                      Obx(() => CustomText(
                        text: controller.selectedMap.value?.title ?? 'Floormap',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor424242,
                      )),
                    ],
                  ),
                  Icon(Icons.search,
                      size: 24.sp, color: AppColors.textColor424242),
                ],
              ),
            ),
          ),

          // ── Map image with zoom ──────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Map image with transformation controller
                Obx(() {
                  final map = controller.selectedMap.value;
                  return InteractiveViewer(
                    transformationController: controller.transformationController,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: map != null && map.imageUrl.isNotEmpty
                        ? Image.network(
                          map.imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return _shimmerMap();
                          },
                          errorBuilder: (_, __, ___) => _errorMap(),
                        )
                        : _shimmerMap(),
                  );
                }),

                // Floor map list navigation chips (top left)
                Obx(() {
                  if (controller.floorMaps.length > 1) {
                    return Positioned(
                      top: 20.h,
                      left: 20.w,
                      right: 120.w,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            controller.floorMaps.length,
                            (i) => GestureDetector(
                              onTap: () {
                                controller.selectedMap.value = controller.floorMaps[i];
                                controller.selectedIndex.value = i;
                              },
                              child: Obx(() => Container(
                                margin: EdgeInsets.only(right: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: controller.selectedIndex.value == i
                                      ? const Color(0xff5BB8AE)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: controller.selectedIndex.value == i
                                        ? const Color(0xff5BB8AE)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: CustomText(
                                  text: controller.floorMaps[i].title,
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: controller.selectedIndex.value == i
                                      ? Colors.white
                                      : AppColors.textColor424242,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Zoom buttons (top right) - moved lower to avoid overlap
                Positioned(
                  top: 70.h,
                  right: 20.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: controller.zoomIn,
                          icon: Icon(Icons.add, size: 20.sp),
                          tooltip: 'Zoom In',
                        ),
                        VerticalDivider(
                            thickness: 1,
                            color: Colors.grey.shade300),
                        IconButton(
                          onPressed: controller.zoomOut,
                          icon: Icon(Icons.remove, size: 20.sp),
                          tooltip: 'Zoom Out',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────────────
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => TextButton(
                  onPressed: controller.recenter,
                  child: Row(
                    children: [
                      Icon(Icons.center_focus_strong,
                          size: 16.sp,
                          color: controller.showAllArea.value == false && controller.scale.value == 1.0
                              ? const Color(0xff5BB8AE)
                              : AppColors.textColor424242),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: 'Recenter',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.showAllArea.value == false && controller.scale.value == 1.0
                            ? const Color(0xff5BB8AE)
                            : AppColors.textColor424242,
                      ),
                    ],
                  ),
                )),
                Obx(() => TextButton(
                  onPressed: controller.toggleShowAllArea,
                  child: Row(
                    children: [
                      Icon(Icons.fullscreen,
                          size: 16.sp,
                          color: controller.showAllArea.value
                              ? const Color(0xff5BB8AE)
                              : AppColors.textColor424242),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: 'Show all area',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.showAllArea.value
                            ? const Color(0xff5BB8AE)
                            : AppColors.textColor424242,
                      ),
                      if (controller.showAllArea.value)
                        SizedBox(width: 4.w),
                      if (controller.showAllArea.value)
                        Icon(Icons.check,
                            color: Colors.green, size: 16.sp),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerMap() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _errorMap() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined,
              size: 64.sp, color: Colors.grey.shade400),
          SizedBox(height: 12.h),
          CustomText(
            text: 'Failed to load map image',
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
          ),
        ],
      ),
    );
  }
}
