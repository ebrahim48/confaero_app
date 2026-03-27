import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/attendees_details_controller.dart';
import '../attendee_action_button.dart';
import '../attendee_contact_info.dart';
import '../attendee_profile_header.dart';

class AttendeeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? args;
  const AttendeeDetailsScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final AttendeeDetailsController controller = Get.put(
      AttendeeDetailsController(),
    );

    // Load real data from API if args contain attendeeId
    final attendeeId = args?['attendeeId'] as String? ?? '';
    final eventId = args?['eventId'] as String? ??
        (Get.isRegistered<SessionController>()
            ? SessionController.to.eventId
            : '');

    if (attendeeId.isNotEmpty && eventId.isNotEmpty) {
      controller.loadAttendeeDetails(eventId, attendeeId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          Obx(() => CustomAppBarWidget(
            title: controller.attendeeDetails['name']?.toString().isNotEmpty == true
                ? controller.attendeeDetails['name']
                : 'Attendee',
          )),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final attendee = controller.attendeeDetails;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Image
                    Container(
                      width: double.infinity,
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        image: const DecorationImage(
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
                              imagePath: attendee['image'] ?? 'assets/images/sampleprofile.png',
                              name: attendee['name'] ?? '',
                              company: attendee['company'] ?? '',
                              role: attendee['role'] ?? 'Attendee',
                              sessions: attendee['sessions'] ?? '0 sessions',
                              isBookmarked: attendee['isBookmarked'] ?? false,
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
                              email: attendee['email'] ?? '',
                              phone: attendee['phone'] ?? '',
                              location: attendee['location'] ?? '',
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
                                      () => controller.requestToConnect(eventId),
                                ),
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
}
