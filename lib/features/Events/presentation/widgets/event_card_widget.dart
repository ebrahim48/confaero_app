import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final bool isNetworkImage;
  final String title;
  final String date;
  final String location;
  final bool isRegistered;
  final String? registrationStatus;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onCardTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    this.isNetworkImage = false,
    required this.title,
    required this.date,
    required this.location,
    this.isRegistered = false,
    this.registrationStatus,
    this.onRegisterTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.infinity,
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 6,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: _buildImage(),
            ),
            SizedBox(width: 12.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                              AppColors.textColor424242, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: date,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: location,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor7E7F7E,
                          textAlign: TextAlign.start,
                          maxline: 1,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      _actionButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // No URL — shimmer placeholder
    if (imageUrl.isEmpty) return _shimmerBox();

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: 86.w,
        height: 86.h,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _shimmerBox();
        },
        errorBuilder: (_, __, ___) => _shimmerBox(),
      );
    }

    return Image.asset(
      imageUrl,
      width: 86.w,
      height: 86.h,
      fit: BoxFit.cover,
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: 86.w,
        height: 86.h,
        color: Colors.white,
      ),
    );
  }

  Widget _actionButton() {
    if (isRegistered) {
      final label = registrationStatus == 'PENDING' ? 'Pending' : 'Registered';
      final color = registrationStatus == 'PENDING'
          ? const Color(0xFFFFA726)
          : AppColors.primaryColor32A69A;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.textColorD2D2D2),
        ),
        child: CustomText(
          text: label,
          fontsize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor707070,
        ),
      );
    }

    return GestureDetector(
      onTap: onRegisterTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
    );
  }
}