import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/resources_controller.dart';
import '../character_limit_text.dart';
import '../custom_app_bar_widget.dart';
import '../multiline_text_field_widget.dart';
import '../qa_expansiontile_widget.dart';
import '../resources_poll_card.dart';
import '../resources_tab_widget.dart';
import '../survey_radio_option.dart';
import '../survey_star_rating_widgets.dart';
import 'poll_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResourcesController controller = Get.put(ResourcesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Resources',
          ),

          // Tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: TabButton(
                      text: 'Q&A',
                      isSelected: controller.selectedTabIndex.value == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TabButton(
                      text: 'Polls',
                      isSelected: controller.selectedTabIndex.value == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TabButton(
                      text: 'Survey',
                      isSelected: controller.selectedTabIndex.value == 2,
                      onTap: () => controller.changeTab(2),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Divider
          Container(
            height: 1.h,
            color: const Color(0xffE0E0E0),
          ),

          // Content
          Expanded(
            child: Obx(() {
              // Q&A Tab
              if (controller.selectedTabIndex.value == 0) {
                return ListView.builder(
                  padding: EdgeInsets.all(24.w),
                  itemCount: controller.qaList.length,
                  itemBuilder: (context, index) {
                    final qa = controller.qaList[index];
                    return QAExpansionTile(
                      question: qa['question'],
                      answer: qa['answer'],
                      isExpanded: qa['isExpanded'],
                      onTap: () => controller.toggleQA(index),
                    );
                  },
                );
              }

              // Polls Tab
              else if (controller.selectedTabIndex.value == 1) {
                return ListView.builder(
                  padding: EdgeInsets.all(24.w),
                  itemCount: controller.pollsList.length,
                  itemBuilder: (context, index) {
                    final poll = controller.pollsList[index];
                    return PollCard(
                      title: poll['title'],
                      creator: poll['creator'],
                      responses: poll['responses'],
                      onAnswerTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PollScreen(),
                          ),
                        );
                      },
                      onMenuTap: () {
                        // Menu action
                      },
                    );
                  },
                );
              }

              // resources_screen.dart এর Survey tab এ এই code দিন:

// Survey Tab
              else {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      CustomText(
                        text: 'Event Feedback Survey',
                        fontsize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 4.h),

                      // Subtitle
                      CustomText(
                        text: 'Please share your experience.',
                        fontsize: 14.sp,
                        color: const Color(0xff757575),
                      ),
                      SizedBox(height: 24.h),

                      // Question 1: Rating
                      CustomText(
                        text: '1. How would you rate this event?',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 12.h),

                      Obx(() {
                        return StarRating(
                          rating: controller.selectedRating.value,
                          onRatingChanged: (rating) {
                            controller.setRating(rating);
                          },
                        );
                      }),
                      SizedBox(height: 24.h),

                      // Question 2: Yes/No
                      CustomText(
                        text: '2. Was the sessions content helpful?',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 12.h),

                      Obx(() {
                        return Column(
                          children: [
                            RadioOption(
                              text: 'Yes',
                              isSelected: controller.selectedOption.value == 'Yes',
                              onTap: () => controller.setOption('Yes'),
                            ),
                            RadioOption(
                              text: 'No',
                              isSelected: controller.selectedOption.value == 'No',
                              onTap: () => controller.setOption('No'),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 24.h),

                      // Question 3: Suggestions
                      CustomText(
                        text: '3. Any suggestions? (optional)',
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff252525),
                      ),
                      SizedBox(height: 12.h),

                      // Text Area
                      MultiLineTextField(
                        controller: controller.suggestionController,
                        hintText: 'Write your message',
                        height: 120.h,
                        maxLines: 5,
                        maxLength: 200,
                      ),

                      const CharacterLimitText(limit: 80),
                      SizedBox(height: 32.h),

                      CustomButton(title: 'Submit Survey', onpress: () {

                      },)
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}