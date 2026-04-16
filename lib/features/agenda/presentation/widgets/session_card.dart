import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../global/custom_assets/assets.gen.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SessionCard extends StatelessWidget {
  final String type;
  final String title;
  final String duration;
  final int attendees;
  final int favorites;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final bool isBreak;
  final String? location;

  const SessionCard({
    super.key,
    required this.type,
    required this.title,
    required this.duration,
    this.attendees = 0,
    this.favorites = 0,
    this.onFavorite,
    this.onTap,
    this.isBreak = false,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    // Break Card Style
    if (isBreak) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xffE0F2F1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: duration,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff252525),
                ),
                SizedBox(width: 8.w),
                Assets.icons.coffee.svg()

              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.start,
                    text: title,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                    maxline: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (location != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: const Color(0xff757575),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: location!,
                    fontsize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    }

    // Regular Session Card Style - FIXED VERSION
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left green accent bar
            Container(
              width: 5.w,
              color: const Color(0xff5BB8AE),
            ),

            // Main content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffE0E0E0), width: 0.5),
                    right: BorderSide(color: Color(0xffE0E0E0), width: 0.5),
                    bottom: BorderSide(color: Color(0xffE0E0E0), width: 0.5),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff5BB8AE),
                              borderRadius: BorderRadius.circular(4.r),
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

                          // Duration
                          CustomText(
                            text: duration,
                            fontsize: 14.sp,
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
                                onTap: onFavorite,
                                child: Icon(
                                  favorites > 0
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16.sp,
                                  color: favorites > 0
                                      ? const Color(0xffE53935)
                                      : const Color(0xff757575),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: favorites.toString(),
                                fontsize: 12.sp,
                                color: const Color(0xff757575),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Calendar icon (top right)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Assets.icons.calendar1.svg(),
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