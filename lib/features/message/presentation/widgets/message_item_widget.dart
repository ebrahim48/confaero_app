import 'package:confaero_app/presentations/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/models/message_model.dart';

class MessageItemWidget extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onTap;

  const MessageItemWidget({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: NetworkImage(message.avatarUrl),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    maxline: 6,
                    text:
                    message.name,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text:
                    message.message,
                    maxline: 6,
                    textOverflow: TextOverflow.ellipsis,
               fontsize: 14,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                    CustomText(text:
                      message.time,
                  fontsize: 12,
                  fontWeight: FontWeight.w600,
                ),
                if (message.hasUnread) ...[
                  SizedBox(height: 4.h),
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
