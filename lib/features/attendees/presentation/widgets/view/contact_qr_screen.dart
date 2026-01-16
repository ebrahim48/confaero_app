import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/checkin_checkout_controller.dart';
import '../qr_item_widget.dart';

class ContactQrScreen extends StatefulWidget {
  const ContactQrScreen({super.key});

  @override
  State<ContactQrScreen> createState() => _ContactQrScreenState();
}

class _ContactQrScreenState extends State<ContactQrScreen>
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
                    text: 'Contact & QR',
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
                children: [
                  // QR Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffE0E0E0),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40.sp,
                                  color: AppColors.textColor7E7F7E,
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Name
                        CustomText(
                          text: 'Albert Flamingo',
                          fontsize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor424242,
                        ),

                        SizedBox(height: 8.h),

                        // Role Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            text: 'Attendee',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor7E7F7E,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // QR Code
                        Container(
                          width: 180.w,
                          height: 180.h,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xffE0E0E0),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/qr.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.qr_code,
                                  size: 120.sp,
                                  color: AppColors.textColor7E7F7E,
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Use this code to
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            textAlign: TextAlign.start,
                            text: 'Use this code to',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor424242,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Info Items
                        QrInfoItem(
                          icon: 'assets/icons/checkin.svg',
                          text: 'Check in',
                        ),
                        QrInfoItem(
                          icon: 'assets/icons/share.svg',
                          text:
                          'Share your Contact info with Exhibitors/Vendors',
                        ),
                        QrInfoItem(
                          icon: 'assets/icons/userprofile.svg',
                          text: 'Connect with fellow attendees',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Scan Button
                  CustomButton(
                    title: 'Scan an attendee',
                    onpress: () {
                      controller.scanAttendeeQR(context);
                    },
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
                    prefixIcon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                  ),

                  // Show scanned attendees count if any
                  Obx(() {
                    if (controller.scannedAttendees.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 16.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xffE0E0E0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: const Color(0xff32A69A),
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomText(
                              text:
                              'Scanned ${controller.scannedAttendees.length} attendee${controller.scannedAttendees.length > 1 ? 's' : ''}',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor424242,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showScannedList(context);
                            },
                            child: CustomText(
                              text: 'View',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff32A69A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScannedList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Scanned Attendees',
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor424242,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: Obx(
                    () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.scannedAttendees.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: const Color(0xff32A69A),
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomText(
                              text: controller.scannedAttendees[index],
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor424242,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}