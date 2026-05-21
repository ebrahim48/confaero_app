import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../announcements/data/models/announcement_model.dart';
import '../../../../../core/constants/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
  });

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('d MMM yyyy · hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  bool _isNew(String raw) {
    if (raw.isEmpty) return false;
    try {
      return DateTime.now()
          .difference(DateTime.parse(raw).toLocal())
          .inHours < 24;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _isNew(announcement.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isNew
                ? AppColors.primaryColor32A69A.withOpacity(0.3)
                : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (announcement.image.isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12.r)),
                child: CachedNetworkImage(
                  imageUrl: announcement.image,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 160.h,
                    color: const Color(0xFFF0F0F0),
                    child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor32A69A),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 160.h,
                    color: const Color(0xFFF0F0F0),
                    child: Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey[400], size: 32.r),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + New badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          announcement.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF252525),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isNew) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor32A69A,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'New',
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Description
                  if (announcement.description.isNotEmpty)
                    Text(
                      announcement.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF7E7F7E),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  SizedBox(height: 10.h),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 11.sp, color: const Color(0xFFAAAAAA)),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDate(announcement.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFAAAAAA),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          size: 16.sp, color: const Color(0xFFCCCCCC)),
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
}
