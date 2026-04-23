import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class LeadCard extends StatelessWidget {
  final Map<String, dynamic> lead;
  final VoidCallback onAddNote;
  final VoidCallback onEditTags;

  const LeadCard({
    super.key,
    required this.lead,
    required this.onAddNote,
    required this.onEditTags,
  });

  @override
  Widget build(BuildContext context) {
    final tags = (lead['tags'] as List<String>);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + info + time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: AssetImage(lead['image']),
                backgroundColor: AppColors.borderColorD2D2D2,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead['name'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      lead['role'],
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor7E7F7E),
                    ),
                    SizedBox(height: 6.h),
                    // Tags row
                    if (tags.isEmpty)
                      Text(
                        'No tag added',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textColor7E7F7E,
                            fontStyle: FontStyle.italic),
                      )
                    else
                      Wrap(
                        spacing: 6.w,
                        children:
                        tags.map((tag) => _tagBadge(tag)).toList(),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                lead['time'],
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textColor7E7F7E),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Divider(
              height: 1, color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
          SizedBox(height: 8.h),

          // Bottom row: Add Note + Edit Tags
          Row(
            children: [
              GestureDetector(
                onTap: onAddNote,
                child: Row(
                  children: [
                    Icon(Icons.note_alt_outlined,
                        size: 16.sp, color: AppColors.textColor7E7F7E),
                    SizedBox(width: 5.w),
                    Text(
                      'Add Note',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textColor7E7F7E),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEditTags,
                child: Row(
                  children: [
                    Icon(Icons.label_outline,
                        size: 16.sp, color: AppColors.textColor7E7F7E),
                    SizedBox(width: 5.w),
                    Text(
                      'Edit Tags',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textColor7E7F7E),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagBadge(String tag) {
    Color bg;
    Color text;

    switch (tag) {
      case 'Hot Lead':
        bg = const Color(0xffFDE8E8);
        text = const Color(0xffC0392B);
        break;
      case 'Follow-Up':
        bg = const Color(0xffE8F8F5);
        text = const Color(0xff32A69A);
        break;
      case 'Demo':
        bg = const Color(0xffFFF9E6);
        text = const Color(0xffE5A000);
        break;
      case 'Reached':
        bg = const Color(0xffECF0FF);
        text = const Color(0xff4A6CF7);
        break;
      default:
        bg = const Color(0xffF0F0F0);
        text = const Color(0xff7E7F7E);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        tag,
        style: TextStyle(
            fontSize: 10.sp, color: text, fontWeight: FontWeight.w500),
      ),
    );
  }
}