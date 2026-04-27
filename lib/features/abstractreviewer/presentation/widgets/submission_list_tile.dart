import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/reviewer_models.dart';

class SubmissionListTile extends StatelessWidget {
  final AuthorModel author;
  final VoidCallback onTap;

  const SubmissionListTile({
    super.key,
    required this.author,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.borderColorD2D2D2,
              backgroundImage: author.avatar.isNotEmpty
                  ? CachedNetworkImageProvider(author.avatar)
                  : null,
              child: author.avatar.isEmpty
                  ? Icon(Icons.person, size: 24.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(author.name,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor252525)),
                      Text(_formatDate(author.lastSubmittedAt),
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(author.role,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor7E7F7E)),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      _chip(author.role.isNotEmpty ? author.role : 'Author'),
                      SizedBox(width: 6.w),
                      Text('${author.totalFiles} file${author.totalFiles == 1 ? '' : 's'}',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E)),
                      if (author.pending > 0) ...[
                        SizedBox(width: 6.w),
                        _pendingBadge(author.pending),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right,
                size: 20.sp, color: AppColors.textColor7E7F7E),
          ],
        ),
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
      return '';
    }
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

  Widget _pendingBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xffFFF8E6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text('$count pending',
          style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xffE5A000),
              fontWeight: FontWeight.w500)),
    );
  }
}
