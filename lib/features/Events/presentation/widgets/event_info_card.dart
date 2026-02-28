import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      width: 345.w,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Event Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: isNetworkImage
                ? Image.network(
              imageUrl,
              width: 84.w,
              height: 84.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
                : Image.asset(
              imageUrl,
              width: 84.w,
              height: 84.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12.w),

          // Event Details
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

  Widget _fallback() {
    return Image.asset(
      'assets/images/myevents.png',
      width: 84.w,
      height: 84.h,
      fit: BoxFit.cover,
    );
  }
}