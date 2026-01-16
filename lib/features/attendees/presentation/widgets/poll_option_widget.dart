import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class PollOptionWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const PollOptionWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE8F5F3) : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xff32A69A)
                : const Color(0xffD2D2D2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color:
                isSelected ? const Color(0xff32A69A) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff32A69A)
                      : const Color(0xffD2D2D2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: isSelected
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 14.sp,
              )
                  : null,
            ),

            SizedBox(width: 12.w),

            // Option text
            Expanded(
              child: CustomText(
                text: text,
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor424242,
              ),
            ),
          ],
        ),
      ),
    );
  }
}