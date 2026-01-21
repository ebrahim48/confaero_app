import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/connectionlist_controller.dart';

class ConnectionCardWidget extends StatelessWidget {
  final Connection connection;
  final VoidCallback onBookmarkTap;
  final VoidCallback onSayHi;
  final VoidCallback onSendMail;

  const ConnectionCardWidget({
    super.key,
    required this.connection,
    required this.onBookmarkTap,
    required this.onSayHi,
    required this.onSendMail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xff9E9E9E),
          width: 0.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Avatar, Info, Bookmark
          Row(
            children: [
              // Avatar
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    connection.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: connection.name,
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: connection.company,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ],
                ),
              ),

              // Bookmark Icon
              Padding(
                padding:  EdgeInsets.only(top: 12,left: 12,right: 12,bottom: 34),
                child: GestureDetector(
                  onTap: onBookmarkTap,
                  child: SvgPicture.asset(
                    connection.isBookmarked
                        ? 'assets/icons/star.svg'
                        : 'assets/icons/star_outline.svg',
                    width: 20.w,
                    height: 20.h,
                    colorFilter: ColorFilter.mode(
                      connection.isBookmarked
                          ? const Color(0xffFFD700)
                          : AppColors.textColor252525,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Divider
          Divider(
            height: 1,
            thickness: 0.5,
            color: const Color(0xff9E9E9E),
          ),

          SizedBox(height: 12.h),

          // Bottom Row: Role, Events, Sessions with circle backgrounds
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  text: connection.role,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor7E7F7E,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  text: '${connection.eventsCount} Events',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor7E7F7E,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  text: '${connection.sessionsCount} sessions',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor7E7F7E,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSayHi,
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffD7EAE8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14.sp,
                          color: const Color(0xff32A69A),
                        ),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: 'Say Hi',
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff32A69A),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: GestureDetector(
                  onTap: onSendMail,
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 14.sp,
                          color: AppColors.textColor424242,
                        ),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: 'Send Mail',
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor424242,
                        ),
                      ],
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
}