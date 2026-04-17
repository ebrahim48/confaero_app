import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/about_event_card_widget.dart';
import '../category_item_widgets.dart';
import '../sponsor_banner_widgets.dart';
import 'package:confaero_app/core/config/approutes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  final String eventId;

  const HomeScreen({super.key, this.eventId = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayName = 'Hello!';

  @override
  void initState() {
    super.initState();
    final eventId = widget.eventId.isNotEmpty ? widget.eventId : '';
    controller = Get.put(HomeController(eventId: eventId));
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await PrefsHelper.getString(AppConstants.name);
    if (mounted && name.isNotEmpty) {
      setState(() {
        _displayName = 'Hello $name!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: _displayName,
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor424242,
                              textAlign: TextAlign.start,
                            ),
                            CustomText(
                              text: controller.currentDate,
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor7E7F7E,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => context.pushNamed(
                                AppRoutes.notificationsScreen,
                              ),
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
                          onTap: () => controller.openDrawer(_scaffoldKey),
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

            // Event Banner — dynamic
            Obx(() {
              final home = controller.eventHome.value;
              return Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  bottom: 12.w,
                  top: 12.w,
                  right: 12.h,
                ),
                child: Stack(
                  children: [
                    // Banner image
                    ClipRRect(
                      child:
                          home != null && home.banner.isNotEmpty
                              ? Image.network(
                                home.banner,
                                width: double.infinity,
                                height: 289.h,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, progress) {
                                  if (progress == null) return child;
                                  return _shimmerBanner();
                                },
                                errorBuilder:
                                    (_, __, ___) => Image.asset(
                                      'assets/images/homebanner.png',
                                      width: double.infinity,
                                      height: 289.h,
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : controller.isLoading.value
                              ? _shimmerBanner()
                              : Image.asset(
                                'assets/images/homebanner.png',
                                width: double.infinity,
                                height: 289.h,
                                fit: BoxFit.cover,
                              ),
                    ),

                    // Title overlay
                    Positioned(
                      top: 16.h,
                      left: 16.w,
                      right: 16.w,
                      child:
                          controller.isLoading.value && home == null
                              ? _shimmerText(200.w, 20.h)
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: home?.title ?? '',
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                    ),

                    // Date + Venue overlay
                    Positioned(
                      bottom: 65.h,
                      left: 16.w,
                      right: 16.w,
                      child:
                          controller.isLoading.value && home == null
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _shimmerText(120.w, 14.h),
                                  SizedBox(height: 4.h),
                                  _shimmerText(200.w, 14.h),
                                ],
                              )
                              : Column(
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
                                        text: home?.formattedDateRange ?? '',
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
                                              home != null
                                                  ? 'Venue: ${home.venue}'
                                                  : '',
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
              );
            }),

            // Categories Grid — unchanged
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

            // Tags row — unchanged
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed(AppRoutes.photosScreen),
                      child: _buildTag('Photos'),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () => context.pushNamed(AppRoutes.documentScreen),
                      child: _buildTag('Documents'),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap:
                          () =>
                              context.pushNamed(AppRoutes.eventsPostersScreen),
                      child: _buildTag('Poster'),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap:
                          () => context.pushNamed(AppRoutes.jobOpeningsScreen),
                      child: _buildTag('Job'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // About Event — dynamic
            Obx(() {
              final home = controller.eventHome.value;
              return AboutEventCard(
                description: home?.details ?? 'Loading event details...',
                onSeeMore: () {},
              );
            }),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  // Shimmer helpers
  Widget _shimmerBanner() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: 289.h,
        color: Colors.white,
      ),
    );
  }

  Widget _shimmerText(double width, double height) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFBDBDBD),
      highlightColor: const Color(0xFFE0E0E0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
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
        border: Border.all(color: const Color(0xffD2D2D2)),
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
