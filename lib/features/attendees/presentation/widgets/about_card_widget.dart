import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class AboutCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool showImageTop;

  const AboutCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.showImageTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              imagePath,
              width: 345.w,
              height: 146.h,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
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
                SizedBox(height: 12.h),
                CustomText(
                  text: description,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                  textAlign: TextAlign.start,
                  maxline: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}