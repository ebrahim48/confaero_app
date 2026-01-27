import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutSectionWidget extends StatelessWidget {
  final String description;

  const AboutSectionWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF252525),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7E7F7E),
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}