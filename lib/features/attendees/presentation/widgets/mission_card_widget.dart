import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class MissionCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const MissionCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 184.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2829, 0.6635, 0.8491],
          colors: [
            Color(0xFFFFFFFF),
            Color(0xBFEFEFEF),
            Color(0x26999999),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Text Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: CustomText(
                      text: description,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                      textAlign: TextAlign.start,
                      maxline: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              imagePath,
              width: 140.w,
              height: 184.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}