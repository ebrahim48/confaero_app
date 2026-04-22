import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../core/constants/app_colors.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? time;
  final String? attachmentUrl;
  final String? attachmentName;
  final String? mimeType;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    this.time,
    this.attachmentUrl,
    this.attachmentName,
    this.mimeType,
  });

  bool get _isImage {
    if (mimeType != null && mimeType!.startsWith('image/')) return true;
    if (attachmentUrl == null) return false;
    final lower = attachmentUrl!.toLowerCase().split('?').first;
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xFF73AAA6) : const Color(0xFFF5F5F5);
    final textColor = isMe ? Colors.white : AppColors.textColor252525;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image attachment
                if (attachmentUrl != null && _isImage)
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                      bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
                    ),
                    child: Image.network(
                      attachmentUrl!,
                      width: 240.w,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : Container(
                              width: 240.w,
                              height: 160.h,
                              color: bubbleColor,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                      errorBuilder: (_, __, ___) => Container(
                        width: 240.w,
                        height: 80.h,
                        color: bubbleColor,
                        child: Icon(Icons.broken_image, color: textColor.withOpacity(0.5)),
                      ),
                    ),
                  ),

                // File attachment (non-image)
                if (attachmentUrl != null && !_isImage)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insert_drive_file, color: textColor, size: 20.sp),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            attachmentName ?? 'Attachment',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: textColor,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Text (only show if there's actual text beyond just the filename fallback)
                if (message.isNotEmpty && attachmentUrl == null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: CustomText(
                      textAlign: TextAlign.start,
                      maxline: 20,
                      text: message,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),

                // Text alongside attachment (caption)
                if (message.isNotEmpty && attachmentUrl != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 10.h),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 13.sp, color: textColor),
                    ),
                  ),
              ],
            ),
          ),
          if (time != null) ...[
            SizedBox(height: 4.h),
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
