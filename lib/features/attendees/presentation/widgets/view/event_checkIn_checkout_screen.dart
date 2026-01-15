import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/checkin_checkout_controller.dart';
import '../checkinout_card_widget.dart';


class EventCheckInCheckOutScreen extends StatefulWidget {
  const EventCheckInCheckOutScreen({super.key});

  @override
  State<EventCheckInCheckOutScreen> createState() =>
      _EventCheckInCheckOutScreenState();
}

class _EventCheckInCheckOutScreenState extends State<EventCheckInCheckOutScreen>
    with SingleTickerProviderStateMixin {
  final CheckInOutController controller = Get.put(CheckInOutController());

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
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: 'Event Check In/Out',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomText(
                    text: 'How do you want to join this events?',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 24.h),

                  // Check in via QR code
                 CheckInCard(
                    title: '',
                    buttonText: 'Check in via QR code',
                    description:
                    'To enter the event, tap the check-in button and present your verification QR code to the volunteer or gatekeeper. For technical issues,',
                    onButtonPressed: controller.checkInViaQRCode,
                    onContactTap: controller.contactUs,
                    isPrimary: true,
                  ),

                  SizedBox(height: 32.h),

                  // Check in virtual
                 CheckInCard(
                    title: '',
                    buttonText: 'Check in',
                    description:
                    'To enter the virtual event, tap the check-in button and watch the event live. For technical issues,',
                    onButtonPressed: controller.checkInVirtual,
                    onContactTap: controller.contactUs,
                    isPrimary: false,
                  ),

                  SizedBox(height: 32.h),

                  // Check in/out times
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.checkInTime.value.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor424242,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Check in : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: controller.checkInTime.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (controller.checkOutTime.value.isNotEmpty)
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor424242,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Check out : ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: controller.checkOutTime.value,
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}