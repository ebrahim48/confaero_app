import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../features/sponsors/data/models/sponsor_model.dart';
import '../custom_app_bar_widget.dart';

class SponsorsDetailsScreen extends StatelessWidget {
  const SponsorsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sponsor = GoRouterState.of(context).extra as SponsorModel?;

    if (sponsor == null) {
      return Scaffold(
        body: Column(
          children: [
            const CustomAppBarWidget(title: 'Sponsor Details'),
            Expanded(child: _buildShimmer()),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Sponsor Details'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sponsor Logo / Banner
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFD7EAE8)),
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
                      child: sponsor.logoUrl.startsWith('http')
                          ? Image.network(
                              sponsor.logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF5F5F5),
                                child: const Icon(Icons.image_not_supported, size: 48),
                              ),
                            )
                          : Image.asset(
                              'assets/images/sponsorsbanner.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Company Name
                  Text(
                    sponsor.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF252525),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Website
                  if (sponsor.websiteUrl.isNotEmpty)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/https.svg',
                          width: 16.w,
                          height: 16.h,
                          color: const Color(0xFF252525),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            sponsor.websiteUrl,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF252525),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  if (sponsor.websiteUrl.isNotEmpty) SizedBox(height: 8.h),

                  // Email
                  if (sponsor.publicEmail.isNotEmpty)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/email.svg',
                          width: 16.w,
                          height: 16.h,
                          color: const Color(0xFF252525),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            sponsor.publicEmail,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF252525),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 16.h),

                  // Description
                  if (sponsor.description.isNotEmpty)
                    Text(
                      sponsor.description,
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
            SizedBox(height: 16.h),
            Container(height: 22.h, width: 180.w, color: Colors.white),
            SizedBox(height: 12.h),
            Container(height: 16.h, width: 240.w, color: Colors.white),
            SizedBox(height: 8.h),
            Container(height: 16.h, width: 200.w, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
