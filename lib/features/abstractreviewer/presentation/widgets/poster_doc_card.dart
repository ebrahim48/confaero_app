import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/reviewer_models.dart';

class PosterDocCard extends StatelessWidget {
  final SubmissionModel doc;
  final VoidCallback onView;
  final VoidCallback onReject;
  final VoidCallback onReview;

  const PosterDocCard({
    super.key,
    required this.doc,
    required this.onView,
    required this.onReject,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                      color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
                ),
                child: Icon(Icons.image_outlined,
                    color: AppColors.textColor7E7F7E, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.title,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor252525),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 2.h),
                    Text(doc.authorName,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textColor7E7F7E)),
                    SizedBox(height: 2.h),
                    Text('${doc.sizeLabel}  •  ${_formatDate(doc.uploadedAt)}',
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textColor7E7F7E)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onView,
                child: Icon(Icons.remove_red_eye_outlined,
                    size: 20.sp, color: AppColors.textColor7E7F7E),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: AppColors.borderColorD2D2D2.withOpacity(0.6)),
                    ),
                    child: Center(
                      child: Text('Reject',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: onReview,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor32A69A,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text('Review',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return iso.length > 10 ? iso.substring(0, 10) : iso;
    }
  }
}
