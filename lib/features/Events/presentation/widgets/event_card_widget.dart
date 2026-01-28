import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';


class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String location;
  final bool isRegistered;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onCardTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.location,
    this.isRegistered = false,
    this.onRegisterTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 345.w,
        height: 121.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.textColorFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isRegistered
                ? const Color(0xff5BB8AE)
                : const Color(0xffD2D2D2),
            width: isRegistered ? 1 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1F000000),
              blurRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.asset(
                imageUrl,
                width: 86.w,
                height: 86.h,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 12.w),

            // Event Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title with Arrow
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: title,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor424242,
                            maxline: 2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: SvgPicture.asset(
                            'assets/icons/arrow.svg',
                            width: 20.w,
                            height: 20.h,
                            colorFilter: ColorFilter.mode(
                              AppColors.textColor424242,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    // Date
                    CustomText(
                      text: date,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor7E7F7E,
                      textAlign: TextAlign.start,
                    ),
                
                    // Location and Register Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location
                        CustomText(
                          text: location,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                          textAlign: TextAlign.start,
                        ),
                
                        // Register Button or Status
                        isRegistered
                            ? GestureDetector(
                          onTap: onRegisterTap,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color:  AppColors.primaryColor32A69A.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.textColorD2D2D2
                              )
                            ),
                            child: CustomText(
                              text: 'Registered',
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor707070,
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: onRegisterTap,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff5BB8AE),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: CustomText(
                              text: 'Join Now',
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColorFFFFFF,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}