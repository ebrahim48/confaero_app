import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExhibitorInfoWidget extends StatelessWidget {
  final String name;
  final String category;

  const ExhibitorInfoWidget({
    super.key,
    required this.name,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF252525),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          category,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7E7F7E),
          ),
        ),
      ],
    );
  }
}