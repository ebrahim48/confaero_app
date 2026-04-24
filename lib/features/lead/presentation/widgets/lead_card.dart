import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../controller/leadmanagement_controller.dart';

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
    final tags = lead['tags'] as List<String>;
    final note = lead['note'] as String? ?? '';
    final hasNote = note.isNotEmpty;

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
                backgroundColor: AppColors.borderColorD2D2D2,
                backgroundImage: _buildAvatar(lead['image'] as String? ?? ''),
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
                    // Tags
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
                        children: tags.map((tag) => _tagBadge(tag)).toList(),
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

          // Note section — only shown if note exists
          if (hasNote) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xffE8E8E8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_alt_outlined,
                      size: 13.sp, color: const Color(0xff32A69A)),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      note,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor424242,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 10.h),
          Divider(
              height: 1, color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
          SizedBox(height: 8.h),

          // Bottom row: Add/Edit Note + Edit Tags
          Row(
            children: [
              GestureDetector(
                onTap: onAddNote,
                child: Row(
                  children: [
                    Icon(Icons.note_alt_outlined,
                        size: 16.sp,
                        color: hasNote
                            ? const Color(0xff32A69A)
                            : AppColors.textColor7E7F7E),
                    SizedBox(width: 5.w),
                    Text(
                      hasNote ? 'Edit Note' : 'Add Note',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: hasNote
                              ? const Color(0xff32A69A)
                              : AppColors.textColor7E7F7E,
                          fontWeight: hasNote
                              ? FontWeight.w600
                              : FontWeight.w400),
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

  ImageProvider _buildAvatar(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }
    return const AssetImage('assets/images/profile.png');
  }

  Widget _tagBadge(String tag) {
    Color bg;
    Color textColor;

    switch (tag) {
      case 'HOT':
        bg = const Color(0xffFDE8E8);
        textColor = const Color(0xffC0392B);
        break;
      case 'FOLLOW_UP':
        bg = const Color(0xffE8F8F5);
        textColor = const Color(0xff32A69A);
        break;
      case 'GENERAL':
        bg = const Color(0xffF0F0F0);
        textColor = const Color(0xff7E7F7E);
        break;
      default:
        bg = const Color(0xffF0F0F0);
        textColor = const Color(0xff7E7F7E);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        tagDisplayLabel(tag),
        style: TextStyle(
            fontSize: 10.sp, color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
