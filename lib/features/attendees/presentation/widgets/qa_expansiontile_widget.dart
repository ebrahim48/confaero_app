import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class QAExpansionTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const QAExpansionTile({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Question Header
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: question,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff252525),
                      maxline: isExpanded ? null : 2,
                      textOverflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 24.sp,
                    color: const Color(0xff252525),
                  ),
                ],
              ),
            ),
          ),

          // Answer (Expandable)
          if (isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: CustomText(
                textAlign: TextAlign.start,
                text: answer,
                fontsize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff757575),
                maxline: 2,
              ),
            ),
        ],
      ),
    );
  }
}