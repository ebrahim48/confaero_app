import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/volunteer_models.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isHistory;
  final VoidCallback onComplete;
  final VoidCallback onViewDetails;

  const TaskCard({
    super.key,
    required this.task,
    required this.isHistory,
    required this.onComplete,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _borderColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusBadge,
                SizedBox(height: 6.h),
                Text(task.title,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor252525)),
                SizedBox(height: 4.h),
                if (_formatDate(task.startDate).isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 11.sp, color: AppColors.textColor7E7F7E),
                      SizedBox(width: 3.w),
                      Text(_formatDate(task.startDate),
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E)),
                    ],
                  ),
                if (_formatTimeRange(task.startDate, task.endDate).isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 11.sp, color: AppColors.textColor7E7F7E),
                      SizedBox(width: 3.w),
                      Text(_formatTimeRange(task.startDate, task.endDate),
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E)),
                    ],
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 13.sp, color: AppColors.textColor7E7F7E),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(task.location,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textColor7E7F7E),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                if (!isHistory) ...[
                  SizedBox(height: 12.h),
                  _actionButton,
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _thumbnail,
        ],
      ),
    );
  }

  Widget get _statusBadge {
    Color bg;
    Color text;
    String label;
    switch (task.status) {
      case 'PENDING':
        bg = const Color(0xffEAF4FF);
        text = const Color(0xff1A73E8);
        label = 'Pending';
        break;
      case 'IN_PROGRESS':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        label = 'In Progress';
        break;
      case 'DUE':
        bg = const Color(0xffFFEBEB);
        text = const Color(0xffD32F2F);
        label = 'Due';
        break;
      case 'COMPLETED':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        label = 'Completed';
        break;
      case 'REPORTED':
        bg = const Color(0xffFFF8E6);
        text = const Color(0xffE5A000);
        label = 'Reported';
        break;
      default:
        bg = const Color(0xffF0F0F0);
        text = AppColors.textColor7E7F7E;
        label = task.status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11.sp, fontWeight: FontWeight.w500, color: text)),
    );
  }

  Widget get _actionButton {
    if (task.status == 'PENDING' || task.status == 'IN_PROGRESS' || task.status == 'DUE') {
      return Row(
        children: [
          GestureDetector(
            onTap: onViewDetails,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xffE0E0E0),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text('View Details',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242)),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onComplete,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor32A69A,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text('Complete',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text('View Details',
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor424242)),
      ),
    );
  }

  Widget get _thumbnail {
    final url = task.referenceImage;
    final isNetworkImage = url.startsWith('http') &&
        !url.contains('s3-url/sample') &&
        url.isNotEmpty;
    if (isNetworkImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          url,
          width: 90.w,
          height: 90.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _assetThumb,
        ),
      );
    }
    return _assetThumb;
  }

  Widget get _assetThumb => ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.asset(
          'assets/images/booth.png',
          width: 90.w,
          height: 90.h,
          fit: BoxFit.cover,
        ),
      );

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatTimeRange(String start, String end) {
    if (start.isEmpty) return '';
    try {
      final s = DateTime.parse(start);
      String result = _toAmPm(s);
      if (end.isNotEmpty) {
        final e = DateTime.parse(end);
        result += ' - ${_toAmPm(e)}';
      }
      return result;
    } catch (_) {
      return '';
    }
  }

  String _toAmPm(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  Color get _borderColor {
    switch (task.status) {
      case 'PENDING':
        return const Color(0xff1A73E8);
      case 'IN_PROGRESS':
        return AppColors.primaryColor32A69A;
      case 'DUE':
        return const Color(0xffD32F2F);
      case 'COMPLETED':
        return AppColors.primaryColor32A69A;
      case 'REPORTED':
        return const Color(0xffE5A000);
      default:
        return AppColors.borderColorD2D2D2;
    }
  }
}
