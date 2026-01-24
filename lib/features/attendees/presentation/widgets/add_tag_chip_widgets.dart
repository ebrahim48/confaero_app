import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const TagChip({
    super.key,
    required this.tag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xffE0F2F1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xff32A69A),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: tag,
            fontsize: 13.sp,
            color: const Color(0xff32A69A),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: const Color(0xff32A69A),
            ),
          ),
        ],
      ),
    );
  }
}