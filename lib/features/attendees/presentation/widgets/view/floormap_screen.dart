import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/floormap_controller.dart';
import '../../widgets/view_map_button_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../location_list_item.dart';

class FloorMapScreen extends StatefulWidget {
  const FloorMapScreen({super.key});

  @override
  State<FloorMapScreen> createState() => _FloorMapScreenState();
}

class _FloorMapScreenState extends State<FloorMapScreen>
    with SingleTickerProviderStateMixin {
  final FloorMapController controller = Get.put(FloorMapController());

  @override
  Widget build(BuildContext context) {
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // View Map Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ViewMapButton(
                      onTap: controller.openMap,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Location List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.locations.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Color(0xffE0E0E0),
                    ),
                    itemBuilder: (context, index) {
                      return LocationListItem(
                        title: controller.locations[index],
                        onTap: () =>
                            controller.navigateToLocation(context, index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}