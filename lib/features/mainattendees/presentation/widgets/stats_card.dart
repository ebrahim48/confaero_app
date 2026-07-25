import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';

class StatsCard extends StatelessWidget {
  final String count;
  final String label;

  const StatsCard({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166.5.w,
      height: 89.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xffE1E1E1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: count,
            fontsize: 32.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff252525),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            fontsize: 14.sp,
            color: const Color(0xff757575),
          ),
        ],
      ),
    );
  }
}