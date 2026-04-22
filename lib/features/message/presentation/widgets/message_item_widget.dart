import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';
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
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xffD7EAE8),
              backgroundImage: message.avatarUrl.isNotEmpty
                  ? NetworkImage(message.avatarUrl) as ImageProvider
                  : null,
              child: message.avatarUrl.isEmpty
                  ? Icon(Icons.person, size: 24.sp, color: const Color(0xff32A69A))
                  : null,
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: message.name.isNotEmpty ? message.name : 'User',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 3.h),
                  CustomText(
                    text: message.message,
                    fontsize: 13.sp,
                    color: message.hasUnread
                        ? const Color(0xff252525)
                        : const Color(0xff9E9E9E),
                    fontWeight: message.hasUnread ? FontWeight.w500 : FontWeight.w400,
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: message.time,
                  fontsize: 11.sp,
                  color: message.hasUnread
                      ? const Color(0xff32A69A)
                      : const Color(0xff9E9E9E),
                  fontWeight: message.hasUnread ? FontWeight.w600 : FontWeight.w400,
                ),
                if (message.hasUnread) ...[
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: const BoxDecoration(
                      color: Color(0xff32A69A),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      message.unreadCount > 99 ? '99+' : '${message.unreadCount}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
