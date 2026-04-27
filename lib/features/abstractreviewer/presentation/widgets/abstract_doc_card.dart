import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/reviewer_models.dart';

class AbstractDocCard extends StatelessWidget {
  final SubmissionModel doc;
  final VoidCallback onView;
  final VoidCallback onReject;
  final VoidCallback onRevise;
  final VoidCallback onApprove;

  const AbstractDocCard({
    super.key,
    required this.doc,
    required this.onView,
    required this.onReject,
    required this.onRevise,
    required this.onApprove,
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
                  color: const Color(0xffFFF0F0),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red, size: 22.sp),
                    Text('PDF',
                        style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
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
                child: _btn(
                  label: 'Reject',
                  icon: Icons.close,
                  color: Colors.red,
                  bgColor: Colors.white,
                  borderColor: Colors.red.withOpacity(0.4),
                  onTap: onReject,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _btn(
                  label: 'Revise',
                  icon: Icons.refresh,
                  color: AppColors.primaryColor32A69A,
                  bgColor: Colors.white,
                  borderColor: AppColors.primaryColor32A69A.withOpacity(0.4),
                  onTap: onRevise,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _btn(
                  label: 'Approve',
                  icon: Icons.check,
                  color: Colors.white,
                  bgColor: AppColors.primaryColor32A69A,
                  borderColor: AppColors.primaryColor32A69A,
                  onTap: onApprove,
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

  Widget _btn({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13.sp, color: color),
            SizedBox(width: 3.w),
            Text(label,
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
