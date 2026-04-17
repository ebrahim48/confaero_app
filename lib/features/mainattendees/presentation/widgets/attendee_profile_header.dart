import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class AttendeeProfileHeader extends StatelessWidget {
  final String imagePath;
  final String name;
  final String company;
  final String role;
  final String sessions;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  const AttendeeProfileHeader({
    super.key,
    required this.imagePath,
    required this.name,
    required this.company,
    required this.role,
    required this.sessions,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imagePath.startsWith('http://') || imagePath.startsWith('https://');
    final imageProvider = isNetworkImage
        ? NetworkImage(imagePath)
        : AssetImage(imagePath) as ImageProvider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image (Left Aligned)
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xff32A69A),
              width: 3,
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Name, Company and Bookmark
        SizedBox(
          width: 345.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Company
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: company,
                    fontsize: 14.sp,
                    color: const Color(0xff757575),
                  ),
                ],
              ),

              // Bookmark Icon
              GestureDetector(
                onTap: onBookmarkTap,
                child: Icon(
                  isBookmarked ? Icons.star : Icons.star_border,
                  size: 32.sp,
                  color: isBookmarked
                      ? const Color(0xffFFC107)
                      : const Color(0xff252525),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Role Badge and Sessions
        Row(
          children: [
            // Role Badge
            Container(
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: CustomText(
                  text: role,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff252525),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Sessions
            CustomText(
              text: sessions,
              fontsize: 12.sp,
              color: const Color(0xff757575),
            ),
          ],
        ),
      ],
    );
  }
}