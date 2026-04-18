import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/connection_details_controller.dart';

class ConnectionDetailsScreen extends StatefulWidget {
  final String connectionId;
  const ConnectionDetailsScreen({super.key, required this.connectionId});

  @override
  State<ConnectionDetailsScreen> createState() => _ConnectionDetailsScreenState();
}

class _ConnectionDetailsScreenState extends State<ConnectionDetailsScreen> {
  late final ConnectionDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConnectionDetailsController());
    controller.loadDetails(widget.connectionId);
  }

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
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textColor424242),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Connection Details',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  Obx(() {
                    final c = controller.connection.value;
                    if (c == null) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: controller.toggleBookmark,
                      child: Icon(
                        c.isBookmarked ? Icons.star : Icons.star_border,
                        size: 24.sp,
                        color: c.isBookmarked ? const Color(0xffFFD700) : AppColors.textColor424242,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return _Shimmer();
              final c = controller.connection.value;
              if (c == null) {
                return Center(
                  child: CustomText(
                    text: 'Connection not found',
                    fontsize: 14.sp,
                    color: AppColors.textColor7E7F7E,
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner
                    Container(
                      width: double.infinity,
                      height: 160.h,
                      color: const Color(0xffD7EAE8),
                      child: Center(
                        child: Icon(Icons.people_alt_outlined, size: 64.sp, color: const Color(0xff32A69A)),
                      ),
                    ),

                    // Profile card overlapping banner
                    Transform.translate(
                      offset: Offset(0, -40.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar + name card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
                              ),
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 72.w,
                                    height: 72.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xff32A69A), width: 2),
                                    ),
                                    child: ClipOval(
                                      child: c.avatarUrl.startsWith('http')
                                          ? Image.network(c.avatarUrl, fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _personIcon())
                                          : _personIcon(),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomText(
                                    text: c.name,
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor424242,
                                  ),
                                  SizedBox(height: 4.h),
                                  if (c.company.isNotEmpty)
                                    CustomText(
                                      text: c.company,
                                      fontsize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor7E7F7E,
                                    ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _badge(c.role),
                                      SizedBox(width: 8.w),
                                      _badge('${c.sessionsCount} Sessions'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _actionBtn(
                                    icon: Icons.chat_bubble_outline,
                                    label: 'Say Hi',
                                    color: const Color(0xffD7EAE8),
                                    textColor: const Color(0xff32A69A),
                                    onTap: controller.sayHi,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: _actionBtn(
                                    icon: Icons.mail_outline,
                                    label: 'Send Mail',
                                    color: const Color(0xffF5F5F5),
                                    textColor: AppColors.textColor424242,
                                    onTap: controller.sendMail,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            // Contact info
                            if ((c.email?.isNotEmpty ?? false) ||
                                (c.phone?.isNotEmpty ?? false) ||
                                (c.location?.isNotEmpty ?? false)) ...[
                              _sectionTitle('Contact Information'),
                              SizedBox(height: 12.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                                ),
                                child: Column(
                                  children: [
                                    if (c.email?.isNotEmpty ?? false)
                                      _contactRow(Icons.email_outlined, c.email!),
                                    if (c.phone?.isNotEmpty ?? false)
                                      _contactRow(Icons.phone_outlined, c.phone!),
                                    if (c.location?.isNotEmpty ?? false)
                                      _contactRow(Icons.location_on_outlined, c.location!),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _personIcon() => Container(
        color: Colors.grey[200],
        child: Icon(Icons.person, size: 36.sp, color: Colors.grey[500]),
      );

  Widget _badge(String text) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomText(
          text: text,
          fontsize: 11.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor7E7F7E,
        ),
      );

  Widget _sectionTitle(String title) => CustomText(
        textAlign: TextAlign.start,
        text: title,
        fontsize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor424242,
      );

  Widget _contactRow(IconData icon, String text) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: const Color(0xff32A69A)),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                textAlign: TextAlign.start,
                text: text,
                fontsize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242,
              ),
            ),
          ],
        ),
      );

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: textColor),
              SizedBox(width: 6.w),
              CustomText(text: label, fontsize: 13.sp, fontWeight: FontWeight.w500, color: textColor),
            ],
          ),
        ),
      );
}

class _Shimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 160.h, color: Colors.white),
            Transform.translate(
              offset: Offset(0, -40.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Container(
                      height: 180.h,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
                    ),
                    SizedBox(height: 16.h),
                    Container(height: 44.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r))),
                    SizedBox(height: 24.h),
                    Container(height: 120.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
