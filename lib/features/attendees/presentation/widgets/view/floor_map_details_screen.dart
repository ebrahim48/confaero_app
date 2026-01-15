
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/floormap_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';

class FloorMapDetailsScreen extends StatefulWidget {
  const FloorMapDetailsScreen({super.key});

  @override
  State<FloorMapDetailsScreen> createState() => _FloorMapDetailsScreenState();
}

class _FloorMapDetailsScreenState extends State<FloorMapDetailsScreen>
    with SingleTickerProviderStateMixin {
  late FloorMapController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FloorMapController());
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap:  () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: AppColors.textColor424242,
                        ),
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
                  Icon(
                    Icons.search,
                    size: 24.sp,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          // Main Map Area with Zoom Controls
          Expanded(
            child: Stack(
              children: [
                // Background Map Image
                Obx(() => Transform.scale(
                  scale: controller.scale.value,
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.contain,
                    width: 519.047607421875.w,
                    height: 436.0000305175781.h,
                  ),
                )),

                // Zoom Buttons (Top Right)
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: controller.zoomOut,
                          icon: Icon(Icons.remove, size: 20.sp),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                        IconButton(
                          onPressed: controller.zoomIn,
                          icon: Icon(Icons.add, size: 20.sp),
                        ),
                      ],
                    ),
                  ),
                ),

                // CATL Booth Pin (Red Pin + Bubble)
                Positioned(
                  top: 332.h,
                  left: 156.w,
                  child: GestureDetector(
                    onTap: () {
                      // Show tooltip or popup
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          content: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6.r,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.close, size: 18.sp),
                                  ),
                                ),
                                CustomText(
                                  text: 'CATL booth',
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 143.w,
                      height: 116.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(width: 1.w, color: Colors.grey),
                      ),
                      child: Image.asset('assets/images/catl.png'),
                    ),
                  ),
                ),

                // Green Pins (Example positions — adjust as needed)
                ...[
                  Positioned(
                    top: 250.h,
                    left: 100.w,
                    child: Icon(Icons.location_on, color: Colors.green, size: 24.sp),
                  ),
                  Positioned(
                    top: 400.h,
                    left: 300.w,
                    child: Icon(Icons.location_on, color: Colors.green, size: 24.sp),
                  ),
                  Positioned(
                    top: 300.h,
                    left: 400.w,
                    child: Icon(Icons.location_on, color: Colors.green, size: 24.sp),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Bar: Recenter & Show All Area
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: controller.recenter,
                  child: CustomText(
                    text: 'Recenter',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),
                ),
                Obx(() => TextButton(
                  onPressed: controller.toggleShowAllArea,
                  child: Row(
                    children: [
                      CustomText(
                        text: 'Show all area',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor424242,
                      ),
                      SizedBox(width: 4.w),
                      if (controller.showAllArea.value)
                        Icon(Icons.check, color: Colors.green, size: 16.sp),
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
}