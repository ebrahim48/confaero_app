import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../global/custom_assets/assets.gen.dart';
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
      height: 160.h,
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
          // Background Banner Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: poster.banner.isNotEmpty
                  ? Image.network(
                      poster.banner,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _bannerPlaceholder(),
                    )
                  : _bannerPlaceholder(),
            ),
          ),

          // White overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha:0.85),
                    Colors.white.withValues(alpha:0.2),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 13.r,
                      backgroundImage: poster.authorAvatar.isNotEmpty
                          ? NetworkImage(poster.authorAvatar)
                          : null,
                      backgroundColor: const Color(0xFFE0E0E0),
                      child: poster.authorAvatar.isEmpty
                          ? Icon(Icons.person, size: 14.sp, color: Colors.grey)
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: poster.authorName,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525,
                        maxline: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                // Title
                CustomText(
                  textAlign: TextAlign.start,
                  text: poster.title,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor252525,
                  maxline: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Description
                CustomText(
                  textAlign: TextAlign.start,
                  text: poster.description,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                  maxline: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Upload Date
                CustomText(
                  textAlign: TextAlign.start,
                  text: 'Due: ${poster.dueDate}',
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),

                const Spacer(),


                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Download Button
                      GestureDetector(
                        onTap: onDownload,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           Assets.icons.downloadicon.svg(),
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
                            horizontal: 28.w,
                            vertical: 8.h,
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
                            fontsize: 13.sp,
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

  Widget _bannerPlaceholder() => Container(
        color: const Color(0xFFE0E0E0),
        child: Center(child: Icon(Icons.image, color: Colors.grey)),
      );
}