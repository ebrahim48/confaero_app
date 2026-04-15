import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../../data/models/event_model.dart';
import '../../controllers/events_details_controller.dart';
import '../../widgets/shimmer_event_details.dart';
import '../event_info_card.dart';
import '../map_location_widget.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final EventDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EventDetailsController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        final eventId = extra['eventId'] as String? ?? '';
        final registrationStatus = extra['registrationStatus'] as String? ?? '';
        if (eventId.isNotEmpty) {
          controller.loadEvent(eventId, status: registrationStatus);
        }
      } else if (extra is String && extra.isNotEmpty) {
        // Fallback for old navigation calls
        controller.loadEvent(extra);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final event = controller.event.value;
          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,
                          size: 24.sp, color: AppColors.textColor424242),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: controller.isLoading.value && event == null
                          ? _shimmerTitle()
                          : CustomText(
                        text: event?.title ?? 'Event Details',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor424242,
                        textAlign: TextAlign.start,
                        maxline: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(child: _buildBody(event)),
            ],
          );
        }),
      ),
    );
  }

  Widget _shimmerTitle() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: 18.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildBody(EventModel? event) {
    // Shimmer loading
    if (controller.isLoading.value && event == null) {
      return const ShimmerEventDetails();
    }

    // Error
    if (controller.errorMessage.isNotEmpty && event == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 12.h),
            CustomText(
              text: controller.errorMessage.value,
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                final extra = GoRouterState.of(context).extra;
                if (extra is String) controller.loadEvent(extra);
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xff5BB8AE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: CustomText(
                  text: 'Retry',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (event == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          _buildBanner(event),

          SizedBox(height: 24.h),

          // Event Info Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: EventInfoCard(
              imageUrl: event.bannerImageUrl ?? '',
              isNetworkImage:
              event.bannerImageUrl != null && event.bannerImageUrl!.isNotEmpty,
              title: event.title,
              date: event.formattedDateRange,
              location: event.location,
            ),
          ),

          SizedBox(height: 16.h),

          // Map
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: MapLocationCard(
              locationName: event.location,
              onTap: controller.openMap,
            ),
          ),

          SizedBox(height: 24.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _buildDescription(event),
          ),

          // // Extra info (price / type)
          // if (event.price != null || event.eventType != null) ...[
          //   SizedBox(height: 16.h),
          //   Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 24.w),
          //     child: _buildExtraInfo(event),
          //   ),
          // ],

          SizedBox(height: 32.h),

          // Registration
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _buildRegistrationSection(event),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  Widget _buildBanner(EventModel event) {
    if (event.bannerImageUrl != null && event.bannerImageUrl!.isNotEmpty) {
      return Image.network(
        event.bannerImageUrl!,
        width: double.infinity,
        height: 190.h,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _shimmerBanner();
        },
        errorBuilder: (_, __, ___) => _shimmerBanner(),
      );
    }
    return _shimmerBanner();
  }

  Widget _shimmerBanner() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: 190.h,
        color: Colors.white,
      ),
    );
  }

  // ── Description ───────────────────────────────────────────────────────────

  Widget _buildDescription(EventModel event) {
    final desc = event.details?.isNotEmpty == true
        ? event.details!
        : 'No description available for this event.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Event Description',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 12.h),
        CustomText(
          text: desc,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
          textAlign: TextAlign.start,
          maxline: 6,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {},
          child: CustomText(
            text: 'See More',
            fontsize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5BB8AE),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  // ── Extra Info ────────────────────────────────────────────────────────────

  // Widget _buildExtraInfo(EventModel event) {
  //   return Row(
  //     children: [
  //       if (event.eventType != null) ...[
  //         _infoChip(icon: Icons.event_outlined, label: event.eventType!),
  //         SizedBox(width: 12.w),
  //       ],
  //       if (event.price != null)
  //         _infoChip(
  //           icon: Icons.attach_money,
  //           label: event.price == 0
  //               ? 'Free'
  //               : '\$${event.price!.toStringAsFixed(0)}',
  //         ),
  //     ],
  //   );
  // }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xff5BB8AE).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border:
        Border.all(color: const Color(0xff5BB8AE).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xff5BB8AE)),
          SizedBox(width: 4.w),
          CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff5BB8AE),
          ),
        ],
      ),
    );
  }



  Widget _buildRegistrationSection(EventModel event) {
    // Already registered — show status + Go to Event button
    if (controller.isAlreadyRegistered) {
      return Column(
        children: [
          // Registered badge
          Container(
            width: double.infinity,
            height: 54.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff5BB8AE).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xff5BB8AE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    color: const Color(0xff5BB8AE), size: 20.sp),
                SizedBox(width: 8.w),
                CustomText(
                  text: controller.registrationStatusLabel,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff5BB8AE),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Go to Home button (navigates to MainNavigationScreen)
          GestureDetector(
            onTap: () {
              final event = controller.event.value;
              if (event != null && event.id.isNotEmpty) {
                // Navigate to main navigation screen (role-based home)
                context.goNamed(AppRoutes.mainNavigationScreen);
              }
            },
            child: Container(
              width: double.infinity,
              height: 46.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff5BB8AE),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Go to Home',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.home_rounded,
                      color: Colors.white, size: 18.sp),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Invitation code input
    if (controller.showInvitationInput.value) {
      return Column(
        children: [
          CustomTextField(
            controller: controller.invitationCodeController,
            hintText: 'Enter event invitation code',
            contentPaddingHorizontal: 16.w,
            contentPaddingVertical: 14.h,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            title: 'Join',
            onpress: controller.joinWithInvitationCode,
            loading: controller.isLoading.value,
            height: 48.h,
            borderRadius: 8.r,
          ),
        ],
      );
    }

    // Default: Not registered
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: CustomText(
                    text: 'Not Registered?',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor424242,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: controller.isRegistering.value
                      ? null
                      : () => controller.registerNow(context),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xff5BB8AE),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: controller.isRegistering.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : CustomText(
                      text: 'Register Now',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildRegistrationSection(EventModel event) {
  //   // Already registered
  //   if (controller.isAlreadyRegistered) {
  //     return Container(
  //       width: double.infinity,
  //       height: 54.h,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         color: const Color(0xff5BB8AE).withOpacity(0.12),
  //         borderRadius: BorderRadius.circular(8.r),
  //         border: Border.all(color: const Color(0xff5BB8AE)),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.check_circle_outline,
  //               color: const Color(0xff5BB8AE), size: 20.sp),
  //           SizedBox(width: 8.w),
  //           CustomText(
  //             text: controller.registrationStatusLabel,
  //             fontsize: 16.sp,
  //             fontWeight: FontWeight.w600,
  //             color: const Color(0xff5BB8AE),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   // Invitation code input
  //   if (controller.showInvitationInput.value) {
  //     return Column(
  //       children: [
  //         CustomTextField(
  //           controller: controller.invitationCodeController,
  //           hintText: 'Enter event invitation code',
  //           contentPaddingHorizontal: 16.w,
  //           contentPaddingVertical: 14.h,
  //         ),
  //         SizedBox(height: 16.h),
  //         CustomButton(
  //           title: 'Join',
  //           onpress: controller.joinWithInvitationCode,
  //           loading: controller.isLoading.value,
  //           height: 48.h,
  //           borderRadius: 8.r,
  //         ),
  //       ],
  //     );
  //   }
  //
  //   // Default: Not registered
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(height: 16.h),
  //       Container(
  //         width: double.infinity,
  //         height: 54.h,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8.r),
  //           border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 decoration: const BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(8),
  //                     bottomLeft: Radius.circular(8),
  //                   ),
  //                 ),
  //                 child: CustomText(
  //                   text: 'Not Registered?',
  //                   fontsize: 14.sp,
  //                   fontWeight: FontWeight.w400,
  //                   color: AppColors.textColor424242,
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: GestureDetector(
  //                 onTap: controller.isRegistering.value
  //                     ? null
  //                     : () => controller.registerNow(context),
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xff5BB8AE),
  //                     borderRadius: BorderRadius.only(
  //                       topRight: Radius.circular(8),
  //                       bottomRight: Radius.circular(8),
  //                     ),
  //                   ),
  //                   child: controller.isRegistering.value
  //                       ? SizedBox(
  //                     width: 20.w,
  //                     height: 20.h,
  //                     child: const CircularProgressIndicator(
  //                       color: Colors.white,
  //                       strokeWidth: 2,
  //                     ),
  //                   )
  //                       : CustomText(
  //                     text: 'Register Now',
  //                     fontsize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}