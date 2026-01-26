import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventSpekarActionButtons extends StatelessWidget {
  final VoidCallback onSayHi;
  final VoidCallback onSendMail;

  const EventSpekarActionButtons({
    super.key,
    required this.onSayHi,
    required this.onSendMail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Say Hi Button
        Expanded(
          child: GestureDetector(
            onTap: onSayHi,
            child: Container(
              height: 102.h,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 28.sp,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Say Hi',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff252525),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),

        // Send Mail Button
        Expanded(
          child: GestureDetector(
            onTap: onSendMail,
            child: Container(
              height: 102.h,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 28.sp,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Send Mail',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff252525),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}