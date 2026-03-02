import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventInfoCard extends StatelessWidget {
  final String imageUrl;
  final bool isNetworkImage;
  final String title;
  final String date;
  final String location;

  const EventInfoCard({
    super.key,
    required this.imageUrl,
    this.isNetworkImage = false,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: _buildImage(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor424242,
                  maxline: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: date,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text: location,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) return _shimmerBox();

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: 84.w,
        height: 84.h,
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
      width: 84.w,
      height: 84.h,
      fit: BoxFit.cover,
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: 84.w,
        height: 84.h,
        color: Colors.white,
      ),
    );
  }
}