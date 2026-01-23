import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/posters_controller.dart';

class PosterCardWidget extends StatelessWidget {
  final PosterModel poster;
  final VoidCallback onDownload;
  final VoidCallback onView;

  const PosterCardWidget({
    super.key,
    required this.poster,
    required this.onDownload,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 134.h,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F000000),
            blurRadius: 6,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Poster Banner Image (Right side)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: Container(
                width: 100.w,
                height: 134.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Image.asset(
                  poster.posterImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE0E0E0),
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 40.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundImage: AssetImage(poster.authorImage),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: const Color(0xFFE0E0E0),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: poster.authorName,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF252525),
                        maxline: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Title
                SizedBox(
                  width: 217.w,
                  child: CustomText(
                    text: poster.title,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF252525),
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),

                // Description
                SizedBox(
                  width: 217.w,
                  child: CustomText(
                    text: poster.description,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    maxline: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),

                // Upload Date
                CustomText(
                  text: 'Uploaded: ${poster.uploadDate}',
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),

                const Spacer(),

                // Action Buttons
                SizedBox(
                  width: 217.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Download Button
                      GestureDetector(
                        onTap: onDownload,
                        child: Row(
                          children: [
                            Icon(
                              Icons.download_outlined,
                              size: 16.sp,
                              color: const Color(0xFF666666),
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: 'download',
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF666666),
                            ),
                          ],
                        ),
                      ),

                      // View Button
                      GestureDetector(
                        onTap: onView,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF0FC3C2),
                                Color(0xFF06B6B4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            text: 'View',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}