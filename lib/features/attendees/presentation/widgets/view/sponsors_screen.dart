import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../controllers/sponsors_controller.dart';
import '../custom_app_bar_widget.dart';

class SponsorsScreen extends StatelessWidget {
  const SponsorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SponsorsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(title: 'Sponsors'),

          // Sponsors Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmer();
              }
              if (controller.sponsors.isEmpty) {
                return const Center(child: Text('No sponsors found'));
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.sponsors.length,
                  itemBuilder: (context, index) {
                    final sponsor = controller.sponsors[index];
                    return _buildSponsorCard(
                      context: context,
                      name: sponsor.name,
                      imagePath: sponsor.logoUrl,
                      onTap: () {
                        controller.logSponsorView(sponsor.id);
                        context.pushNamed(
                          AppRoutes.sponsorsDetailsScreen,
                          extra: sponsor,
                        );
                      },
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSponsorCard({
    required BuildContext context,
    required String name,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 164.w,
        height: 164.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD7EAE8), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              offset: const Offset(1, 1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sponsor Name
            Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF252525),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Sponsor Logo
            Expanded(
              child:
                  imagePath.startsWith('http')
                      ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                      )
                      : Image.asset(
                        'assets/images/panasonic.png', // Fallback
                        fit: BoxFit.contain,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
