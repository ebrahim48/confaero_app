import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../custom_app_bar_widget.dart';

class SponsorsDetailsScreen extends StatelessWidget {
  const SponsorsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Sponsor Details',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sponsor Banner Image
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFD7EAE8),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x26000000),
                          offset: const Offset(1, 1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        'assets/images/sponsorsbanner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Company Name
                  Text(
                    'Tesla, Inc.',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF252525),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Website Link
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/https.svg',
                        width: 16.w,
                        height: 16.h,
                        color: const Color(0xFF252525),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'https://example.com',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF252525),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Email
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/email.svg',
                        width: 16.w,
                        height: 16.h,
                        color: const Color(0xFF252525),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'example@gmail.com',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF252525),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the''',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF252525),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}