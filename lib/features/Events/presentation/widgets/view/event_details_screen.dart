import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../controllers/events_details_controller.dart';
import '../event_info_card.dart';
import '../map_location_widget.dart';


class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  final EventDetailsController controller = Get.put(EventDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),

                  SizedBox(width: 14.w),
                  Expanded(
                    child: CustomText(
                      text: '18th Lithium Supply & Battery...',
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Banner Image
                    Image.asset(
                      'assets/images/banner.png',
                      width: double.infinity,
                      height: 190.h,
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: 24.h),

                    // Event Info Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: EventInfoCard(
                        imageUrl: 'assets/images/myevents.png',
                        title: '18th Lithium Supply & Battery Raw Materials Conference',
                        date: 'Jun 22-25, 2026',
                        location: 'Las Vegas, USA',
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Map Location Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: MapLocationCard(
                        locationName: 'Montreal Convention Centre',
                        onTap: controller.openMap,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Event Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
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
                            text:
                            'For 18 years, the Fastmarkets Lithium Supply and Battery Raw Materials Conference has been the definitive meeting place for the sector. More than 1,300 delegates rely on this platform to negotiate offtake agreements, secure financing, assess market fundamentals and build partnerships across the supply chain.....',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor7E7F7E,
                            textAlign: TextAlign.start,
                            maxline: 6,
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () {
                              // Show full description
                            },
                            child: CustomText(
                              text: 'See More',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5BB8AE),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Registration Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Obx(() {
                        if (controller.showInvitationInput.value) {
                          // Show invitation code input
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
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Already Registered?',
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor424242,
                                textAlign: TextAlign.start,
                                bottom: 12.h,
                              ),
                              CustomButton(
                                title: 'Join with invitation code',
                                onpress: controller.toggleInvitationInput,
                                height: 48.h,
                                borderRadius: 8.r,
                                color: const Color(0xff5BB8AE),
                              ),
                              SizedBox(height: 16.h),
                              Container(
                                width: 400,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFD2D2D2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Left section
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

                                    // Right section (Button)
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: controller.registerNow,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff5BB8AE),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: CustomText(
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
                              )

                            ],
                          );
                        }
                      }),
                    ),
                    SizedBox(height: 40.h),
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