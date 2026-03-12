import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/photos_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../photo_filter_chips.dart';
import '../photogrid_item.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotosController controller = Get.put(PhotosController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(title: 'Photos'),

          SizedBox(height: 16.h),

          // Horizontal Scrollable Filter Chips
          SizedBox(
            height: 28.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: controller.filters.length,
              itemBuilder: (context, index) {
                return PhotoFilterChip(
                  text: controller.filters[index],
                  isSelected: controller.selectedFilter.value == index,
                  onTap: () => controller.changeFilter(index),
                );
              },
            ),
          ),

          SizedBox(height: 20.h),

          // Photos Grid
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7.5.w,
                  mainAxisSpacing: 7.5.h,
                  childAspectRatio: 110.w / 118.h,
                ),
                itemCount: controller.allPhotos.length,
                itemBuilder: (context, index) {
                  return PhotoGridItem(
                    imagePath: controller.allPhotos[index].imageUrl,
                    onTap:
                        () => controller.openPhoto(controller.allPhotos[index]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
