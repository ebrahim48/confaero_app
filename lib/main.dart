import 'dart:io';
import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
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

  // Route every image_picker call through the Android system photo picker so the
  // app never needs READ_MEDIA_IMAGES / READ_MEDIA_VIDEO (Play "Photo and Video
  // Permissions" policy). On Android 11-12 this falls back to the Play Services
  // backported picker, and below that to the SAF document picker — all of which
  // grant per-file access without a runtime permission prompt.
  _useAndroidSystemPhotoPicker();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load prefs before the router is built so the first redirect can read the
  // stored session synchronously (otherwise logged-in users land on onboarding).
  await PrefsHelper.init();

  // Initialize dependency injection
  DependencyInjection.init();

  Get.put(ThemeController());

  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
}

void _useAndroidSystemPhotoPicker() {
  final implementation = ImagePickerPlatform.instance;
  if (implementation is ImagePickerAndroid) {
    implementation.useAndroidPhotoPicker = true;
  }
}

// Android's default MaterialApp scroll behavior uses a stretch overscroll
// indicator whose recede animation can start mid-frame, tripping Flutter's
// "Build scheduled during frame" assertion. Swap it for the classic glow
// indicator to avoid that framework-level timing bug.
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Theme.of(context).colorScheme.primary,
      child: child,
    );
  }
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
            scrollBehavior: _AppScrollBehavior(),
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
