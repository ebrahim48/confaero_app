import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class AttachmentItem extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final IconData fileIcon;
  final VoidCallback onDelete;
  final Color iconColor;

  const AttachmentItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileIcon,
    required this.onDelete,
    this.iconColor = const Color(0xffE53935),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 60.h,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xff9E9E9E).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // File Icon
          Icon(
            fileIcon,
            size: 32.sp,
            color: iconColor,
          ),
          SizedBox(width: 12.w),

          // File Name and Size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: fileName,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff252525),
                  maxline: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: fileSize,
                  fontsize: 12.sp,
                  color: const Color(0xff9E9E9E),
                ),
              ],
            ),
          ),

          // Delete Icon
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xffE53935),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}