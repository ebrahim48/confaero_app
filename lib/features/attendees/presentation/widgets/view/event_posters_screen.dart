import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../controllers/posters_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../../widgets/search_field_widget.dart';
import '../postercard_widgets.dart';

class EventsPostersScreen extends StatelessWidget {
  const EventsPostersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostersController());

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Posters'),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: SearchFieldWidget(
              controller: controller.searchController,
              hint: 'Search posters, title, etc',
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _PostersShimmer();
              }

              if (controller.filteredPosters.isEmpty) {
                return Center(
                  child: Text(
                    'No posters found',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                itemCount: controller.filteredPosters.length,
                itemBuilder: (context, index) {
                  final poster = controller.filteredPosters[index];
                  return PosterCardWidget(
                    poster: poster,
                    onDownload: () {},
                    onView: () => controller.viewPoster(context, poster.id),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.addPosterScreen),
        backgroundColor: const Color(0xFF32A69A),
        child: Assets.icons.addicon.svg(),
      ),
    );
  }
}

class _PostersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          width: double.infinity,
          height: 160.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
