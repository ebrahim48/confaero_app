import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../custom_app_bar_widget.dart';

class SponsorsScreen extends StatelessWidget {
  const SponsorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sponsors = [
      {'name': 'Tesla', 'image': 'assets/images/tesla.png'},
      {'name': 'CATL', 'image': 'assets/images/catel.png'},
      {'name': 'Panasonic', 'image': 'assets/images/panasonic.png'},
      {'name': 'SAMSUNG SDI', 'image': 'assets/images/samsung.png'},
      {'name': 'BYD Company', 'image': 'assets/images/byd.png'},
      {'name': 'SVOLT Energy', 'image': 'assets/images/svolt.png'},
      {'name': 'MANLY Battery', 'image': 'assets/images/manly.png'},
      {'name': 'EVE Energy', 'image': 'assets/images/eve.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Sponsors',
          ),

          // Sponsors Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1,
                ),
                itemCount: sponsors.length,
                itemBuilder: (context, index) {
                  final sponsor = sponsors[index];
                  return _buildSponsorCard(
                    context: context,
                    name: sponsor['name']!,
                    imagePath: sponsor['image']!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorCard({
    required BuildContext context,
    required String name,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.sponsorsDetailsScreen);
      },
      child: Container(
        width: 164.w,
        height: 164.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFD7EAE8),
            width: 1,
          ),
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
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}