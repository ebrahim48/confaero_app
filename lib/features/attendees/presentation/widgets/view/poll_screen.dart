import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../custom_app_bar_widget.dart';
import '../../controllers/resources_controller.dart';
import '../../../../resources/data/models/resource_model.dart';

class PollScreen extends StatefulWidget {
  final PollModel poll;

  const PollScreen({super.key, required this.poll});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  late List<bool> selectedOptions;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(widget.poll.options.length, false);
  }

  void _submitVote() {
    final selectedIndices = <int>[];
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i]) {
        selectedIndices.add(i);
      }
    }

    if (selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Get the controller and submit vote
    final controller = Get.find<ResourcesController>();
    final selectedOptionId = widget.poll.options[selectedIndices.first].id;
    
    controller.submitPollVote(widget.poll.id, selectedOptionId);
    
    setState(() {
      isSubmitting = false;
    });

    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Poll',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Creator Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: const Color(0xffBDBDBD),
                        child: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: 'Poll created by organizer',
                          fontsize: 12.sp,
                          color: const Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Question
                  CustomText(
                    textAlign: TextAlign.start,
                    text: widget.poll.question,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 24.h),

                  Divider(color: AppColors.textColorD2D2D2),

                  SizedBox(height: 24.h),

                  // Options
                  ...List.generate(widget.poll.options.length, (index) {
                    final option = widget.poll.options[index];
                    return GestureDetector(
                      onTap: widget.poll.isActive
                          ? () {
                              setState(() {
                                // Toggle selection
                                selectedOptions[index] = !selectedOptions[index];
                              });
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: selectedOptions[index]
                                ? const Color(0xff32A69A)
                                : const Color(0xff9E9E9E),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectedOptions[index]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 24.sp,
                              color: selectedOptions[index]
                                  ? const Color(0xff32A69A)
                                  : const Color(0xff9E9E9E),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomText(
                                text: option.text,
                                fontsize: 14.sp,
                                color: const Color(0xff252525),
                              ),
                            ),
                            if (option.votes > 0)
                              CustomText(
                                text: '${option.votes}',
                                fontsize: 12.sp,
                                color: const Color(0xff757575),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (!widget.poll.isActive)
                    Container(
                      margin: EdgeInsets.only(top: 16.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20.sp,
                            color: const Color(0xff757575),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'This poll is closed. Results are shown.',
                              fontsize: 12.sp,
                              color: const Color(0xff757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.poll.isActive)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 23.h, horizontal: 23.w),
              child: CustomButton(
                title: isSubmitting ? 'Submitting...' : 'Submit',
                onpress: () {
                  if (!isSubmitting) {
                    _submitVote();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}