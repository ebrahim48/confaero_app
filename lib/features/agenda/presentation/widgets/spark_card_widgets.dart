import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../global/custom_assets/assets.gen.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerCard extends StatelessWidget {
  final String name;
  final String role;
  final String company;
  final String imagePath;
  final VoidCallback onTap;

  const SpeakerCard({
    super.key,
    required this.name,
    required this.role,
    required this.company,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 330.w,
        height: 74.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Speaker Image
            Container(
              width: 49.w,
              height: 49.h,
              margin: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imagePath != null && imagePath!.isNotEmpty
                      ? AssetImage(imagePath!)
                      : AssetImage(Assets.images.profile.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Speaker Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    textAlign: TextAlign.start,
                    text: name,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: role,
                    fontsize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                     textAlign: TextAlign.start,
                    text: company,
                    fontsize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                ],
              ),
            ),

            // Arrow Button
            Container(
              width: 50.w,
              height: 50.h,
              margin: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff0FC3C2), Color(0xff06B6B4)],
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/chevronright.svg',
                  width: 20.w,
                  height: 20.h,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}