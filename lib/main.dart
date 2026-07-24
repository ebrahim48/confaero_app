import 'dart:io';
import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'core/config/approutes/app_routes.dart';
import 'core/config/appthemes/app_themes.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/network_connection.dart';
import 'core/helpers/prefs_helper.dart';
import 'firebase_options.dart';
import 'presentations/controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Silence harmless image-load network failures (e.g. unreachable/placeholder
  // image URLs). These are already handled gracefully by errorWidget/errorBuilder
  // in the UI, so we only suppress the redundant console spam. All other errors
  // are forwarded to the default handler.
  final defaultOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.library == 'image resource service' ||
        details.exception is SocketException) {
      return;
    }
    defaultOnError?.call(details);
  };

  PlatformDispatcher.instance.onAccessibilityFeaturesChanged = () {};

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load prefs before the router is built so the first redirect can read the
  // stored session synchronously (otherwise logged-in users land on onboarding).
  await PrefsHelper.init();

  // Initialize dependency injection
  DependencyInjection.init();

  Get.put(ThemeController());

  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
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
            title: 'ConfAero',
            theme: Themes().lightTheme,
            darkTheme: Themes().darkTheme,
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
        },
      ),
    );
  }
}
