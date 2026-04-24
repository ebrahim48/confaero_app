import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../exhibitors_sponsors_booth/data/models/booth_model.dart';
import '../../controllers/exhibitor_controller.dart';
import '../custom_app_bar_widget.dart';

class ExhibitorScreen extends StatelessWidget {
  const ExhibitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExhibitorController());

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Exhibitors'),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFEFEFE),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search exhibitors_sponsors_booth, booth....',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, size: 22.r, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmer();
              }
              if (controller.booths.isEmpty) {
                return const Center(child: Text('No exhibitors_sponsors_booth found'));
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: controller.booths.length,
                itemBuilder: (context, index) {
                  final booth = controller.booths[index];
                  return _buildExhibitorCard(context: context, booth: booth);
                },
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
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 16.h),
          height: 260.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  Widget _buildExhibitorCard({
    required BuildContext context,
    required BoothModel booth,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.exhibitorDetailsScreen, extra: booth);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D000000),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner with Booth Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: booth.banner.startsWith('http')
                      ? Image.network(
                          booth.banner,
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150.h,
                            color: const Color(0xFFF5F5F5),
                            child: const Icon(Icons.image_not_supported),
                          ),
                        )
                      : Image.asset(
                          'assets/images/exhibitor.png',
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x1A000000),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.storefront_outlined, size: 14.r, color: const Color(0xFF252525)),
                        SizedBox(width: 4.w),
                        Text(
                          'Booth ${booth.boothNumber}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF252525),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booth.companyName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF252525),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    booth.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7E7F7E),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (booth.offerTitle.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_offer_outlined, size: 12.r, color: const Color(0xFF4CAF50)),
                              SizedBox(width: 4.w),
                              Text(
                                booth.offerTitle,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
