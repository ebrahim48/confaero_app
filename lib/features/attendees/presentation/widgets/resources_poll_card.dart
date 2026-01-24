import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class PollCard extends StatelessWidget {
  final String title;
  final String creator;
  final String responses;
  final VoidCallback onAnswerTap;
  final VoidCallback? onMenuTap;

  const PollCard({
    super.key,
    required this.title,
    required this.creator,
    required this.responses,
    required this.onAnswerTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xffE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: title,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff252525),
                ),
              ),
              GestureDetector(
                onTap: onMenuTap,
                child: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: const Color(0xff757575),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Creator Info
          CustomText(
            textAlign: TextAlign.start,
            text: creator,
            fontsize: 12.sp,
            color: const Color(0xff757575),
          ),
          SizedBox(height: 4.h),

          // Response Count
          CustomText(
            textAlign: TextAlign.start,
            text: responses,
            fontsize: 12.sp,
            color: const Color(0xff757575),
          ),
          SizedBox(height: 12.h),

          // Answer Button
          SizedBox(
            width: 120.w,
            height: 36.h,
            child: ElevatedButton(
              onPressed: onAnswerTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32A69A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: CustomText(
                text: 'Answer Poll',
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}