import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class TimelineWidget extends StatelessWidget {
  final String time;
  final bool isFirst;
  final bool isLast;

  const TimelineWidget({
    super.key,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Column(
        children: [
          // Time
          CustomText(
            text: time.split(' ')[0],
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff252525),
          ),
          CustomText(
            text: time.split(' ')[1],
            fontsize: 10.sp,
            color: const Color(0xff757575),
          ),
        ],
      ),
    );
  }
}