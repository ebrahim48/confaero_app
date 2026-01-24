import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/agenda_details_controller.dart';
import '../action_button_widgets.dart';
import '../section_header_widgets.dart';
import '../spark_card_widgets.dart';

class AgendaDetailsScreen extends StatelessWidget {
  const AgendaDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AgendaDetailsController controller = Get.put(AgendaDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Sample session 1:Whova for.....',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Obx(() {
                final session = controller.sessionDetails;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Session Info Card
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xffE0E0E0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x26000000),
                            blurRadius: 6,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Title
                          CustomText(
                            text: session['title'],
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff252525),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),

                          // Date Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.sp,
                                color: const Color(0xff757575),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: CustomText(
                                  text: session['date'],
                                  fontsize: 12.sp,
                                  color: const Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16.sp,
                                color: const Color(0xff757575),
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: session['location'],
                                fontsize: 12.sp,
                                color: const Color(0xff757575),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => controller.viewMap(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD2D2D2),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: CustomText(
                                    text: 'View Map',
                                    fontsize: 10.sp,
                                    color: const Color(0xff252525),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          icon: Icons.question_answer_outlined,
                          text: 'Q&A',
                          onTap: () => controller.openQA(),
                        ),
                        ActionButton(
                          icon: Icons.poll_outlined,
                          text: 'Poll',
                          onTap: () => controller.openPoll(),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          icon: Icons.note_outlined,
                          text: 'Note',
                          onTap: () => controller.openNote(),
                        ),
                        ActionButton(
                          icon: controller.isLiked.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          text: 'Like',
                          onTap: () => controller.toggleLike(),
                          iconColor: controller.isLiked.value
                              ? const Color(0xffE53935)
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Session Overview
                    const SectionHeader(title: 'Session Overview'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: CustomText(
                        text: session['overview'],
                        fontsize: 14.sp,
                        color: const Color(0xff252525),

                      ),
                    ),
                    SizedBox(height: 24.h),

                    // How to Attend
                    const SectionHeader(title: 'How to attend'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: (session['howToAttend'] as List).map((item) {
                          IconData icon;
                          if (item['icon'] == 'desktop') {
                            icon = Icons.desktop_mac_outlined;
                          } else if (item['icon'] == 'video') {
                            icon = Icons.videocam_outlined;
                          } else {
                            icon = Icons.meeting_room_outlined;
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  size: 20.sp,
                                  color: const Color(0xff252525),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text: item['text'],
                                    fontsize: 14.sp,
                                    color: const Color(0xff252525),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Speakers
                    const SectionHeader(title: 'Speakers'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: (session['speakers'] as List).map((speaker) {
                          return SpeakerCard(
                            name: speaker['name'],
                            role: speaker['role'],
                            company: speaker['company'],
                            imagePath: speaker['image'],
                            onTap: () => controller.openSpeakerDetails(speaker),
                          );
                        }).toList(),
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