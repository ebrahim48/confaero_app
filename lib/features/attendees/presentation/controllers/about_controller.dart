import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AboutUsController extends GetxController {


  void onStartNewEvent(BuildContext context) {
    context.pushNamed(AppRoutes.newEventProposalScreen);


  }

  void onSupportEmailTap() {

  }

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();

  }
}