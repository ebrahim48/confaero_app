import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/reviewer_models.dart';

class ReviewerInfoCard extends StatelessWidget {
  final AuthorModel author;

  const ReviewerInfoCard({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.borderColorD2D2D2,
            backgroundImage: author.avatar.isNotEmpty
                ? CachedNetworkImageProvider(author.avatar)
                : null,
            child: author.avatar.isEmpty
                ? Icon(Icons.person, size: 22.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(author.name,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525)),
                SizedBox(height: 2.h),
                Text(author.role,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textColor7E7F7E)),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    _chip(author.role.isNotEmpty ? author.role : 'Author'),
                    SizedBox(width: 6.w),
                    Text('${author.totalFiles} file${author.totalFiles == 1 ? '' : 's'}',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textColor7E7F7E)),
                  ],
                ),
              ],
            ),
          ),
          if (author.pending > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xffFFF8E6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: const BoxDecoration(
                          color: Color(0xffE5A000), shape: BoxShape.circle)),
                  SizedBox(width: 4.w),
                  Text('${author.pending} Pending',
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xffE5A000),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xffF0F0F0),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10.sp, color: AppColors.textColor7E7F7E)),
    );
  }
}
