import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../core/constants/app_colors.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? time;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF73AAA6) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
              ),
            ),
            child: CustomText(
              textAlign: TextAlign.start,
              maxline: 6,
              text: message,
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isMe ? Colors.white : AppColors.textColor252525,
            ),
          ),
          if (time != null) ...[
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomText(
                text: time!,
                fontsize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor7E7F7E,
              ),
            ),
          ],
        ],
      ),
    );
  }
}