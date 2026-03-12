import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/attendees_details_controller.dart';
import '../attendee_action_button.dart';
import '../attendee_contact_info.dart';
import '../attendee_profile_header.dart';

class AttendeeDetailsScreen extends StatelessWidget {
  const AttendeeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendeeDetailsController controller = Get.put(
      AttendeeDetailsController(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(title: 'Mike Sample'),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                final attendee = controller.attendeeDetails;

                return Column(
                  children: [
                    // Banner Image
                    Container(
                      width: double.infinity,
                      height: 180.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mikbanner.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Profile Section (Overlapping)
                    Transform.translate(
                      offset: Offset(0, -40.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Header Widget
                            AttendeeProfileHeader(
                              imagePath: 'assets/images/sampleprofile.png',
                              name: attendee['name'],
                              company: attendee['company'],
                              role: attendee['role'],
                              sessions: attendee['sessions'],
                              isBookmarked: attendee['isBookmarked'],
                              onBookmarkTap: () => controller.toggleBookmark(),
                            ),
                            SizedBox(height: 24.h),

                            // Action Buttons Widget
                            AttendeeActionButtons(
                              onSayHi: () => controller.sayHi(),
                              onSendMail: () => controller.sendMail(),
                            ),
                            SizedBox(height: 32.h),

                            // Contact Info Widget
                            AttendeeContactInfo(
                              email: attendee['email'],
                              phone: attendee['phone'],
                              location: attendee['location'],
                            ),
                            SizedBox(height: 32.h),

                            // Request to Connect Button
                            controller.isRequesting.value
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : CustomButton(
                                  title: 'Request to Connect',
                                  onpress:
                                      () => controller.requestToConnect(
                                        'event_id_placeholder',
                                      ),
                                ),
                            SizedBox(height: 32.h),
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
}
