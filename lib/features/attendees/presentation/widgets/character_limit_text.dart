import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class CharacterLimitText extends StatelessWidget {
  final int limit;

  const CharacterLimitText({
    super.key,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: CustomText(
          text: 'Limit: $limit char',
          fontsize: 12.sp,
          color: const Color(0xff9E9E9E),
        ),
      ),
    );
  }
}