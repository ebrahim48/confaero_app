import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/resources_controller.dart';
import '../custom_app_bar_widget.dart';
import '../multiline_text_field_widget.dart';
import '../qa_expansiontile_widget.dart';
import '../resources_poll_card.dart';
import '../resources_tab_widget.dart';
import '../survey_radio_option.dart';
import '../survey_star_rating_widgets.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  void _showAskQuestionDialog(BuildContext context, ResourcesController controller) {
    final TextEditingController questionCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: CustomText(
            text: 'Ask a Question',
            fontsize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff252525),
          ),
          content: TextField(
            controller: questionCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Type your question here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: CustomText(
                text: 'Cancel',
                fontsize: 14.sp,
                color: const Color(0xff757575),
              ),
            ),
            Obx(() => ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () async {
                      final text = questionCtrl.text.trim();
                      if (text.isEmpty) return;
                      final success = await controller.submitQuestion(text);
                      if (success && ctx.mounted) Navigator.pop(ctx);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32A69A),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : CustomText(
                      text: 'Submit',
                      fontsize: 14.sp,
                      color: Colors.white,
                    ),
            )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResourcesController controller = Get.put(ResourcesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(title: 'Resources'),

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
          Container(height: 1.h, color: const Color(0xffE0E0E0)),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff32A69A),
                  ),
                );
              }

              // Q&A Tab
              if (controller.selectedTabIndex.value == 0) {
                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: const Color(0xff32A69A),
                  child: Column(
                    children: [
                      Expanded(
                        child: controller.qaList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 64.sp,
                                      color: const Color(0xffBDBDBD),
                                    ),
                                    SizedBox(height: 16.h),
                                    CustomText(
                                      text: 'No questions yet',
                                      fontsize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff757575),
                                    ),
                                    SizedBox(height: 8.h),
                                    CustomText(
                                      text: 'Be the first to ask a question!',
                                      fontsize: 14.sp,
                                      color: const Color(0xff9E9E9E),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(24.w),
                                itemCount: controller.qaList.length,
                                itemBuilder: (context, index) {
                                  final qa = controller.qaList[index];
                                  return Obx(
                                    () => QAExpansionTile(
                                      question: qa.question,
                                      answer: qa.answer,
                                      isExpanded: controller.expandedQaIds.contains(qa.id),
                                      onTap: () => controller.toggleQA(qa.id),
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Ask Question Button
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: CustomButton(
                          title: 'Ask a Question',
                          onpress: () => _showAskQuestionDialog(context, controller),
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Polls Tab
              else if (controller.selectedTabIndex.value == 1) {
                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: const Color(0xff32A69A),
                  child: controller.pollsList.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 250.h,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.poll_outlined,
                                      size: 64.sp,
                                      color: const Color(0xffBDBDBD),
                                    ),
                                    SizedBox(height: 16.h),
                                    CustomText(
                                      text: 'No polls available',
                                      fontsize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff757575),
                                    ),
                                    SizedBox(height: 8.h),
                                    CustomText(
                                      text: 'Polls will appear here when created',
                                      fontsize: 14.sp,
                                      color: const Color(0xff9E9E9E),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(24.w),
                          itemCount: controller.pollsList.length,
                          itemBuilder: (context, index) {
                            final poll = controller.pollsList[index];
                            final totalVotes = poll.options.fold<int>(
                              0,
                              (sum, option) => sum + option.votes,
                            );
                            return PollCard(
                              title: poll.question,
                              creator: poll.isActive ? 'Active Poll' : 'Closed Poll',
                              responses: '$totalVotes response(s)',
                              onAnswerTap: () {
                                context.push(
                                  AppRoutes.pollScreen,
                                  extra: poll,
                                );
                              },
                              onMenuTap: () {
                                // Menu action
                              },
                            );
                          },
                        ),

                );
              }
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
                              isSelected:
                                  controller.selectedOption.value == 'Yes',
                              onTap: () => controller.setOption('Yes'),
                            ),
                            RadioOption(
                              text: 'No',
                              isSelected:
                                  controller.selectedOption.value == 'No',
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

                      Obx(() {
                        final error = controller.suggestionError.value;
                        if (error.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: CustomText(
                            text: error,
                            fontsize: 12.sp,
                            color: const Color(0xffE53935),
                            textAlign: TextAlign.start,
                          ),
                        );
                      }),
                      SizedBox(height: 32.h),


                      Obx(() => controller.isSurveyLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              title: 'Submit Survey',
                              onpress: () => controller.submitSurvey(),
                            )),

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
