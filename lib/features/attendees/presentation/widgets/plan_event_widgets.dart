import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';

class PlanEventCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final List<String> features;
  final VoidCallback onStartEvent;
  final VoidCallback? onEmailTap;

  const PlanEventCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.features,
    required this.onStartEvent,
    this.onEmailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2829, 0.6635, 0.8491],
          colors: [
            Color(0xFFFFFFFF),
            Color(0xBFEFEFEF),
            Color(0x26999999),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned(
            right: 0,
            bottom: 0,
            top: 80.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(16.r),
              ),
              child: Image.asset(
                imagePath,
                width: 180.w,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: description,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                  maxline: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16.h),

                // Feature List
                ...features.map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _buildFeatureItem(feature),
                )),

                SizedBox(height: 20.h),

                CustomButton(
                  title: 'Start New Event',
                  onpress: onStartEvent,
                ),
                SizedBox(height: 12.h),

                // Support Email
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onEmailTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Or write to: ',
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                      CustomText(
                        text: AppConstants.supportEmail,
                        fontsize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF32A69A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/checkcircle.svg',
          width: 20.w,
          height: 20.h,
          colorFilter: const ColorFilter.mode(
            Color(0xFF32A69A),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: text,
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF666666),
        ),
      ],
    );
  }
}