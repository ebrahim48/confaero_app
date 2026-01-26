import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String imagePath;

  const SpeakerProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 186.w,
      child: Column(
        children: [
          // Profile Image with Border
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff5BB8AE),
                width: 4,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Name
          CustomText(
            text: name,
            fontsize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff252525),
          ),
          SizedBox(height: 4.h),

          // Role
          CustomText(
            text: role,
            fontsize: 14.sp,
            color: const Color(0xff5BB8AE),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16.sp,
                color: const Color(0xff757575),
              ),
              SizedBox(width: 4.w),
              CustomText(
                text: location,
                fontsize: 14.sp,
                color: const Color(0xff757575),
              ),
            ],
          ),
        ],
      ),
    );
  }
}