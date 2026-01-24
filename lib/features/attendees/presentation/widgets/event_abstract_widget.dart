import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class AbstractCardWidget extends StatelessWidget {
  final String text;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AbstractCardWidget({
    super.key,
    required this.text,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFD7EAE8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: 6,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Abstract',
            fontsize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF252525),
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: text,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
            maxline: isExpanded ? 100 : 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onToggle,
            child: CustomText(
              text: isExpanded ? 'See Less' : 'See More',
              fontsize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF32A69A),
            ),
          ),
        ],
      ),
    );
  }
}