import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/about_controller.dart';
import '../../widgets/about_card_widget.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../../widgets/mission_card_widget.dart';
import '../plan_event_widgets.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutUsController());

    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'About App',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AboutCardWidget(
                    title: 'What is Confaero?',
                    description:
                    'Confaero is a smart platform built to support aviation and event organizers. From conferences to workshops and exhibitions, you can manage registration, schedules, and communication in one place - easily and securely.',
                    imagePath: 'assets/images/aboutbanner.png',
                  ),
                  SizedBox(height: 12.h),

                  // Our Mission Card
                  MissionCardWidget(
                    title: 'Our Mission',
                    description:
                    'Our mission is to make event organizing effortless.\nWe provide the tools, updates, and automation you need so your team can focus on creating meaningful experiences - not managing logistics.',
                    imagePath: 'assets/images/ourmission.png',
                  ),
                  SizedBox(height: 12.h),

                  // Plan Your Event Card
                  PlanEventCardWidget(
                    title: 'Plan Your Event With Confaero',
                    description:
                    'Launch conferences, workshops, exhibitions - all from one platform.',
                    imagePath: 'assets/images/ourmission.png',
                    features: [
                      'Event setup & customization',
                      'Exhibitor & attendee tools',
                      'Real-time updates & alerts',
                      'On-site + virtual support',
                    ],
                    onStartEvent: () => controller.onStartNewEvent(context),
                    onEmailTap: () => controller.onSupportEmailTap(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
