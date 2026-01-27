import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../custom_app_bar_widget.dart';

class ExhibitorScreen extends StatelessWidget {
  const ExhibitorScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final exhibitors = List.generate(
      10,
          (index) => {
        'name': 'TechFlow',
        'booth': 'Booth A-142',
        'description':
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the indus...',
        'offer': '20% Off Annual Plan',
        'category': 'Technology',
        'image': 'assets/images/exhibitor.png',
      },
    );

    return Scaffold(

      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Exhibitors',
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFEFEFE),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search exhibitors, booth....',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 22.r,
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ),

          // Exhibitors List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: exhibitors.length,
              itemBuilder: (context, index) {
                final exhibitor = exhibitors[index];
                return _buildExhibitorCard(
                  context: context,
                  name: exhibitor['name']!,
                  booth: exhibitor['booth']!,
                  description: exhibitor['description']!,
                  offer: exhibitor['offer']!,
                  category: exhibitor['category']!,
                  imagePath: exhibitor['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitorCard({
    required BuildContext context,
    required String name,
    required String booth,
    required String description,
    required String offer,
    required String category,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.exhibitorDetailsScreen);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
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
            // Image with Booth Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
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
                        Icon(
                          Icons.storefront_outlined,
                          size: 14.r,
                          color: const Color(0xFF252525),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booth,
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
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF252525),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Description
                  Text(
                    description,
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

                  // Tags
                  Row(
                    children: [
                      // Offer Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              size: 12.r,
                              color: const Color(0xFF4CAF50),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              offer,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Category Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7E7F7E),
                          ),
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