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
    // Time can be in format "08:00" or "08:00 - 10:00" or "08:00-10:30"
    // We only want to display the start time
    String displayTime = time;
    
    // Remove everything after the first space or dash to get just the start time
    if (time.contains(' - ')) {
      displayTime = time.split(' - ')[0];
    } else if (time.contains('-')) {
      displayTime = time.split('-')[0].trim();
    } else if (time.contains(' ')) {
      displayTime = time.split(' ')[0];
    }

    return SizedBox(
      width: 60.w,
      child: Column(
        children: [
          // Time
          CustomText(
            text: displayTime,
            fontsize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff252525),
          ),
        ],
      ),
    );
  }
}