import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/attendees_details_controller.dart';


class AttendeeDetailsScreen extends StatelessWidget {
  const AttendeeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendeeDetailsController controller = Get.put(AttendeeDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Mike Sample',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                final attendee = controller.attendeeDetails;

                return Column(
                  children: [
                    // Cover Image Area
                    Container(
                      width: double.infinity,
                      height: 120.h,
                      color: const Color(0xffF5F5F5),
                    ),

                    // Profile Section
                    Transform.translate(
                      offset: Offset(0, -40.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            // Profile Image
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: const Color(0xff5BB8AE),
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(attendee['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Name and Company
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    CustomText(
                                      text: attendee['name'],
                                      fontsize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff252525),
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: attendee['company'],
                                      fontsize: 14.sp,
                                      color: const Color(0xff757575),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16.w),

                                // Bookmark
                                GestureDetector(
                                  onTap: () => controller.toggleBookmark(),
                                  child: Icon(
                                    attendee['isBookmarked']
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 28.sp,
                                    color: attendee['isBookmarked']
                                        ? const Color(0xffFFC107)
                                        : const Color(0xff252525),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Role and Sessions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: attendee['role'],
                                  fontsize: 12.sp,
                                  color: const Color(0xff757575),
                                ),
                                SizedBox(width: 16.w),
                                CustomText(
                                  text: attendee['sessions'],
                                  fontsize: 12.sp,
                                  color: const Color(0xff757575),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            // Action Buttons
                            Row(
                              children: [
                                // Say Hi
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.sayHi(),
                                    child: Container(
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline,
                                            size: 20.sp,
                                            color: const Color(0xff252525),
                                          ),
                                          SizedBox(height: 4.h),
                                          CustomText(
                                            text: 'Say Hi',
                                            fontsize: 12.sp,
                                            color: const Color(0xff252525),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Send Mail
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.sendMail(),
                                    child: Container(
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.mail_outline,
                                            size: 20.sp,
                                            color: const Color(0xff252525),
                                          ),
                                          SizedBox(height: 4.h),
                                          CustomText(
                                            text: 'Send Mail',
                                            fontsize: 12.sp,
                                            color: const Color(0xff252525),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            // Contact Info
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomText(
                                text: 'Contact Info',
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff252525),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Email
                            _buildContactItem(
                              Icons.mail_outline,
                              attendee['email'],
                            ),
                            SizedBox(height: 12.h),

                            // Phone
                            _buildContactItem(
                              Icons.phone_outlined,
                              attendee['phone'],
                            ),
                            SizedBox(height: 12.h),

                            // Location
                            _buildContactItem(
                              Icons.location_on_outlined,
                              attendee['location'],
                            ),
                            SizedBox(height: 32.h),

                            // Request to Connect Button
                            SizedBox(
                              width: 345.w,
                              height: 54.h,
                              child: ElevatedButton(
                                onPressed: () => controller.requestToConnect(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff32A69A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: CustomText(
                                  text: 'Request to Connect',
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: const Color(0xff757575),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: text,
              fontsize: 14.sp,
              color: const Color(0xff252525),
            ),
          ),
        ],
      ),
    );
  }
}