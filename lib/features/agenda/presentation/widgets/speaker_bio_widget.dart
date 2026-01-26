import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerBioWidget extends StatelessWidget {
  final String bio;
  final bool isExpanded;
  final VoidCallback onToggle;

  const SpeakerBioWidget({
    super.key,
    required this.bio,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'About/Bio',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xff252525),
        ),
        SizedBox(height: 12.h),

        // Bio Container
        Container(
          width: 345.w,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xffD2D2D2),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x26000000),
                blurRadius: 5,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                textAlign: TextAlign.start,
                text: bio,
                fontsize: 14.sp,
                color: const Color(0xff757575),
                maxline: isExpanded ? 100 : 5,
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: onToggle,
                child: CustomText(
                  text: isExpanded ? 'Read Less' : 'Read More',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff5BB8AE),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}