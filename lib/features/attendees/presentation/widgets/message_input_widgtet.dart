import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class MessageInputWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int currentLength;
  final int maxLength;

  const MessageInputWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.currentLength,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: AppColors.textColor252525,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 8.h),
        Container(
          width: 345.w,
          height: 90.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xFFE1E1E1),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  maxLength: maxLength,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textColor252525,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your message to platform owner',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF999999),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'Limit: $maxLength char',
                    fontsize: 12.sp,
                    color: const Color(0xFF999999),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}