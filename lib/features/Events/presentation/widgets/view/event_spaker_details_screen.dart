import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/event_spekar_details_controller.dart';
import '../event_spekar__contact_info.dart';
import '../event_spekar_action_button.dart';
import '../event_spekar_profile_header.dart';

class EventSpekarDetailsScreen extends StatelessWidget {
  const EventSpekarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventSpekarDetailsController controller = Get.put(
      EventSpekarDetailsController(),
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
                            EventSpekarProfileHeader(
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
                            EventSpekarActionButtons(
                              onSayHi: () => controller.sayHi(),
                              onSendMail: () => controller.sendMail(),
                            ),
                            SizedBox(height: 32.h),

                            // Contact Info Widget
                            EventSpekarContactInfo(
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
                                        controller.currentEventId,
                                        Get.arguments?['speakerId'] ?? Get.arguments?['id'] ?? '',
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
