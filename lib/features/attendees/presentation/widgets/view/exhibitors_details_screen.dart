import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../features/exhibitors/data/models/booth_model.dart';
import '../about_section_widget.dart';
import '../booth_info_widget.dart';
import '../connection_section_widget.dart';
import '../custom_app_bar_widget.dart';
import '../exhibitor_banner_widget.dart';
import '../exhibitor_info_widget.dart';
import '../resources_section_widget.dart';
import '../special_offer_widget.dart';

class ExhibitorDetailsScreen extends StatelessWidget {
  const ExhibitorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booth = GoRouterState.of(context).extra as BoothModel?;

    if (booth == null) {
      return Scaffold(
        body: Column(
          children: [
            const CustomAppBarWidget(title: 'Exhibitor Details'),
            Expanded(child: _buildShimmer()),
          ],
        ),
      );
    }

    final resources = booth.resources
        .map((r) => {'name': r.name, 'url': r.url, 'type': r.type})
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Exhibitor Details'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExhibitorBannerWidget(imagePath: booth.banner),
                  SizedBox(height: 16.h),

                  ExhibitorInfoWidget(
                    name: booth.companyName,
                    category: 'Booth ${booth.boothNumber}',
                  ),
                  SizedBox(height: 16.h),

                  if (booth.offerTitle.isNotEmpty) ...[
                    SpecialOfferWidget(offer: booth.offerTitle),
                    SizedBox(height: 16.h),
                  ],

                  BoothInfoWidget(
                    boothNumber: booth.boothNumber,
                    openingHours: booth.boothOpening,
                  ),
                  SizedBox(height: 24.h),

                  AboutSectionWidget(description: booth.description),
                  SizedBox(height: 24.h),

                  ConnectSectionWidget(
                    website: booth.websiteUrl,
                    email: booth.publicEmail,
                  ),

                  if (resources.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    ResourcesSectionWidget(resources: resources),
                  ],
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 197.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
            SizedBox(height: 16.h),
            Container(height: 24.h, width: 200.w, color: Colors.white),
            SizedBox(height: 8.h),
            Container(height: 16.h, width: 120.w, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
