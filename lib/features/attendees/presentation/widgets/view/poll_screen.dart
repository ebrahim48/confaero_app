import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../custom_app_bar_widget.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final List<String> options = ['Very good', 'Very good', 'Very good'];
  final List<bool> selectedOptions = [false, false, false];

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
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: 'Poll create by organizer, Anthony Ciobanu',
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
                    text: 'Rate your overall event experience.',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 24.h),

                  Divider(color: AppColors.textColorD2D2D2),

                  SizedBox(height: 24.h),

                  // Options
                  ...List.generate(options.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[index] = !selectedOptions[index];
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xff9E9E9E),
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
                            CustomText(
                              text: options[index],
                              fontsize: 14.sp,
                              color: const Color(0xff252525),
                            ),


                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 23,horizontal: 23),
            child: CustomButton(title: 'Submit', onpress: () {

            },),
          ),

          SizedBox(height: 100,),


        ],
      ),
    );
  }
}