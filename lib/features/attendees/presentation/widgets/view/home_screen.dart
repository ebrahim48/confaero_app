import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/about_event_card_widget.dart';
import '../category_item_widgets.dart';
import '../sidebar_drawer.dart';
import '../sponsor_banner_widgets.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,

      drawer: const SidebarDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
                color: AppColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    Container(
                      width: 40.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff252525),
                          width: 0.7,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Hello Text
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Hello Albert!',
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor424242,
                              textAlign: TextAlign.start,
                            ),
                            CustomText(
                              text: 'Wed, 5 Jun, 2025',
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor7E7F7E,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Notification and Menu Icons
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoutes.notificationsScreen);
                          },
                          child: SvgPicture.asset(
                            'assets/icons/notification.svg',
                            width: 24.w,
                            height: 24.h,
                            colorFilter: ColorFilter.mode(
                              AppColors.textColor424242,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            controller.openDrawer();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/menusidebar.svg',
                            width: 24.w,
                            height: 24.h,
                            colorFilter: ColorFilter.mode(
                              AppColors.textColor424242,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Sponsor Banner
            SponsorBanner(
              sponsorName: 'BatteryCrop',
              onTap: () => controller.openSponsorDetails(context),
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: 12.w, bottom: 12.w, top: 12.w, right: 12.h),
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/homebanner.png',
                      width: double.infinity,
                      height: 289.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'The 23nd International Meeting on',
                          fontsize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                        ),
                        CustomText(
                          text: 'Lithium Batteries (iMLB 2026)',
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 65.h,
                    left: 16.w,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: 'June 14-19,2026',
                              fontsize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text:
                                'Venue: palais des congrès de montréal, Conoco',
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                textAlign: TextAlign.start,
                                maxline: 1,
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

            // Categories Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1.05,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return CategoryItem(
                    icon: category['icon']!,
                    label: category['label']!,
                    onTap: () => controller.navigateToCategory(context, index),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.photosScreen);
                      },
                        child: _buildTag('Photos')),
                    SizedBox(width: 12.w),
                    GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.documentScreen);
                        },
                        child: _buildTag('Documents')),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.eventsPostersScreen);
                      },
                        child: _buildTag('Poster')),
                    SizedBox(width: 12.w),
                    GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.jobOpeningsScreen);
                        },
                        child: _buildTag('Job')),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            AboutEventCard(
              description:
              'The iMLB 2026 Scientific and Organizing Committees are pleased to invite you to the 23nd International Meeting on Lithium Batteries, Montreal, Canada from June 14 to 19, 2026.iMLB is the premier forum on lithium-ion batteries as well as current and future applications in electromobili...',
              onSeeMore: () {
                // Navigate to full description
              },
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0x1F7EBBB6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xffD2D2D2),
        ),
      ),
      child: CustomText(
        text: label,
        fontsize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor424242,
      ),
    );
  }
}