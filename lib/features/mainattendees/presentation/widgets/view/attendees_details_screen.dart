import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/attendees_details_controller.dart';

class AttendeeDetailsScreen extends StatefulWidget {
  final String attendeeId;
  const AttendeeDetailsScreen({super.key, required this.attendeeId});

  @override
  State<AttendeeDetailsScreen> createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen> {
  late final AttendeeDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AttendeeDetailsController());
    final eventId = SessionController.to.eventId;
    if (widget.attendeeId.isNotEmpty && eventId.isNotEmpty) {
      controller.loadAttendeeDetails(eventId, widget.attendeeId);
    }
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
                      text: 'Attendee Details',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  Obx(() {
                    final isBookmarked = controller.attendeeDetails['isBookmarked'] as bool? ?? false;
                    return GestureDetector(
                      onTap: controller.toggleBookmark,
                      child: Icon(
                        isBookmarked ? Icons.star : Icons.star_border,
                        size: 24.sp,
                        color: isBookmarked ? const Color(0xffFFD700) : AppColors.textColor424242,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const _DetailsShimmer();

              final attendee = controller.attendeeDetails;
              final imagePath = attendee['image']?.toString() ?? '';
              final isNetworkImage = imagePath.startsWith('http');

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

                    Transform.translate(
                      offset: Offset(0, -40.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile card
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
                                      child: isNetworkImage
                                          ? Image.network(
                                              imagePath,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _personIcon(),
                                            )
                                          : _personIcon(),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomText(
                                    text: attendee['name']?.toString() ?? '',
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor424242,
                                  ),
                                  SizedBox(height: 4.h),
                                  if ((attendee['company']?.toString() ?? '').isNotEmpty)
                                    CustomText(
                                      text: attendee['company'].toString(),
                                      fontsize: 13.sp,
                                      color: AppColors.textColor7E7F7E,
                                    ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _badge(attendee['role']?.toString() ?? 'Attendee'),
                                      SizedBox(width: 8.w),
                                      _badge(attendee['sessions']?.toString() ?? '0 sessions'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(child: _actionBtn(Icons.chat_bubble_outline, 'Say Hi', const Color(0xffD7EAE8), const Color(0xff32A69A), () => controller.sayHi(context))),
                                SizedBox(width: 12.w),
                                Expanded(child: _actionBtn(Icons.mail_outline, 'Send Mail', const Color(0xffF5F5F5), AppColors.textColor424242, controller.sendMail)),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            // Contact info
                            if (((attendee['email']?.toString() ?? '').isNotEmpty) ||
                                ((attendee['phone']?.toString() ?? '').isNotEmpty) ||
                                ((attendee['location']?.toString() ?? '').isNotEmpty)) ...[
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
                                    if ((attendee['email']?.toString() ?? '').isNotEmpty)
                                      _contactRow(Icons.email_outlined, attendee['email'].toString()),
                                    if ((attendee['phone']?.toString() ?? '').isNotEmpty)
                                      _contactRow(Icons.phone_outlined, attendee['phone'].toString()),
                                    if ((attendee['location']?.toString() ?? '').isNotEmpty)
                                      _contactRow(Icons.location_on_outlined, attendee['location'].toString()),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],

                            // Connect button
                            Obx(() => controller.isRequesting.value
                                ? const Center(child: CircularProgressIndicator())
                                : CustomButton(
                                    title: 'Request to Connect',
                                    onpress: () => controller.requestToConnect(
                                      SessionController.to.eventId,
                                      attendee['accountId']?.toString() ?? attendee['id']?.toString() ?? '',
                                    ),
                                  )),
                            SizedBox(height: 32.h),
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
        decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(12.r)),
        child: CustomText(text: text, fontsize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textColor7E7F7E),
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
                color: AppColors.textColor424242,
              ),
            ),
          ],
        ),
      );

  Widget _actionBtn(IconData icon, String label, Color bg, Color fg, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: fg),
              SizedBox(width: 6.w),
              CustomText(text: label, fontsize: 13.sp, fontWeight: FontWeight.w500, color: fg),
            ],
          ),
        ),
      );
}

class _DetailsShimmer extends StatelessWidget {
  const _DetailsShimmer();

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
                      height: 200.h,
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
