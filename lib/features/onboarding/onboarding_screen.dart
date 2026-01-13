import 'package:confaero_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:confaero_app/features/onboarding/presentation/widgets/onboarding_content_widget.dart';
import 'package:confaero_app/features/onboarding/presentation/widgets/onboarding_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../presentations/widgets/custom_button.dart';
import '../../presentations/widgets/custom_text.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final PageController _pageController = PageController();
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    controller.goToPage(index);
                  },
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = controller.onboardingData[index];
                    return OnboardingContent(
                      image: data['image'] as String,
                      title: data['title'] as String,
                      description: data['description'] as String,
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Obx(() => CustomButton(
                      title: controller.currentPage.value == 0
                          ? 'Continue'
                          : 'Next',
                      onpress: () {
                        if (controller.currentPage.value <
                            controller.onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Navigate to Sign Up screen
                          controller.completeOnboarding();
                        }
                      },
                      height: 52.h,
                      borderRadius: 10.r,
                    )),

                    // Skip intro button (hide on first page, show on other pages)
                    Obx(() => controller.currentPage.value != 0
                        ? GestureDetector(
                      onTap: () => controller.skipIntro(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: CustomText(
                          text: 'Skip intro',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor424242,
                        ),
                      ),
                    )
                        : SizedBox(height: 16.h)),
                    SizedBox(height: 30.h),
                    // Page Indicators
                    Obx(() => OnboardingIndicator(
                      currentIndex: controller.currentPage.value,
                      itemCount: controller.onboardingData.length,
                    )),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}