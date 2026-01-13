import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xffE1E1E1),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CustomText(
            text: text,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff7E7F7E),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xffE1E1E1),
          ),
        ),
      ],
    );
  }
}