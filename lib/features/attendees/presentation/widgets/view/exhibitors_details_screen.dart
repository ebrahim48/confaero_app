import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(
            title: 'Exhibitor Details',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image
                  const ExhibitorBannerWidget(
                    imagePath: 'assets/images/exhibitor.png',
                  ),

                  SizedBox(height: 16.h),

                  // Company Info
                  const ExhibitorInfoWidget(
                    name: 'TchFlow',
                    category: 'Software & Technology',
                  ),

                  SizedBox(height: 16.h),

                  // Special Offer
                  const SpecialOfferWidget(
                    offer: '20% Off Annual Plan',
                  ),

                  SizedBox(height: 16.h),

                  // Booth Info
                  const BoothInfoWidget(
                    boothNumber: 'A-12',
                    openingHours: '7:00 AM - 10:00AM',
                  ),

                  SizedBox(height: 24.h),

                  // About Section
                   AboutSectionWidget(
                    description:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
                  ),

                  SizedBox(height: 24.h),

                  // Connect Section
                  const ConnectSectionWidget(
                    website: 'https://example.com',
                    email: 'example@gmailcom',
                  ),

                  SizedBox(height: 24.h),

                  // Resources Section
                  const ResourcesSectionWidget(
                    resources: [
                      {
                        'name': '2025_Product_Catalog.pdf',
                        'size': '2.4 MB',
                      },
                    ],
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