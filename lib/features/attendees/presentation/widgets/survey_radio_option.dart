import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class RadioOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const RadioOption({
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
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xffD2D2D2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff32A69A)
                      : const Color(0xffD2D2D2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff32A69A),
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                textAlign: TextAlign.start,
                text: text,
                fontsize: 14.sp,
                color: const Color(0xff252525),
              ),
            ),
          ],
        ),
      ),
    );
  }
}