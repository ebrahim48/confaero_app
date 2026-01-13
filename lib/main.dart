import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'core/config/approutes/app_routes.dart';
import 'core/config/appthemes/app_themes.dart';

import 'core/helpers/network_connection.dart';
import 'presentations/controller/theme_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onAccessibilityFeaturesChanged = () {};



  // DependencyInjection di = DependencyInjection();
  // di.dependencies();
  // di.lockDevicePortrait();

  Get.put(ThemeController());



  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Confaero App',
              theme: Themes().lightTheme,
              darkTheme: Themes().lightTheme,
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              themeMode: Get.find<ThemeController>().themeMode.value,
              routeInformationParser: AppRoutes.goRouter.routeInformationParser,
              routeInformationProvider:
              AppRoutes.goRouter.routeInformationProvider,
              routerDelegate: AppRoutes.goRouter.routerDelegate,
              builder: (context, child) {
                return Scaffold(body: NoInterNetScreen(child: child!));
              },
            );
          }),
    );
  }
}

