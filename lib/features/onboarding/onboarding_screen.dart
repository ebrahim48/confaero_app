// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../core/constants/app_colors.dart';
// import '../../../global/custom_assets/assets.gen.dart';
// import '../../presentations/widgets/custom_text.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30.r),
//               child: Assets.images.splashImage1.image(
//                 fit: BoxFit.cover,
//                 color: Colors.black.withValues(alpha: 0.3),
//                 colorBlendMode: BlendMode.darken,
//               ),
//             ),
//           ),
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: Column(
//               children: [
//                 const Spacer(flex: 8),
//                 Assets.images.logo.image(),
//                 SizedBox(height: 11.h),
//                 CustomText(
//                   text: "mo'tivate",
//                   fontsize: 50.sp,
//                   color: AppColors.textColorFFFFFF,
//                 ),
//                 SizedBox(height: 3.h),
//                 CustomText(
//                   text: 'BUILD THE BODY YOU DESERVE',
//                   fontsize: 14.sp,
//                   color: AppColors.textColorFFFFFF.withValues(alpha: 0.6),
//                 ),
//                 const Spacer(flex: 3),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15.w),
//                   child: CustomButton(
//                     title: 'Get Started',
//                     onpress: () {
//                       context.pushNamed(AppRoutes.signUpScreen);
//                     },
//                     color: AppColors.textColor5E4D3C,
//                     borderColor: AppColors.textColor5E4D3C,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomText(
//                       text: 'Already have an account? ',
//                       fontsize: 14.sp,
//                       color: AppColors.textColorFFFFFF.withValues(alpha: 0.7),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // context.pushNamed(AppRoutes.logInScreen);
//                       },
//                       child: CustomText(
//                         text: ' Log In',
//                         fontsize: 14.sp,
//                         color: AppColors.textColorFFFFFF,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 18.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
