import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerSessionCard extends StatelessWidget {
  final String type;
  final String title;
  final String time;
  final int attendees;
  final bool isFavorited;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const SpeakerSessionCard({
    super.key,
    required this.type,
    required this.title,
    required this.time,
    required this.attendees,
    required this.isFavorited,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345.w,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(20.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: const Color(0xff5BB8AE), width: 5),
                top: BorderSide(color: const Color(0xffE0E0E0), width: 0.5),
                right: BorderSide(color: const Color(0xffE0E0E0), width: 0.5),
                bottom: BorderSide(color: const Color(0xffE0E0E0), width: 0.5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff5BB8AE),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: CustomText(
                      text: type,
                      fontsize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Title
                  CustomText(
                    textAlign: TextAlign.start,
                    text: title,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                    maxline: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Time
                  CustomText(
                    text: time,
                    fontsize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                  SizedBox(height: 12.h),

                  // Footer
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16.sp,
                        color: const Color(0xff757575),
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: attendees.toString(),
                        fontsize: 12.sp,
                        color: const Color(0xff757575),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 16.sp,
                          color:
                              isFavorited
                                  ? const Color(0xffE53935)
                                  : const Color(0xff757575),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: isFavorited ? '1' : '0',
                        fontsize: 12.sp,
                        color: const Color(0xff757575),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
