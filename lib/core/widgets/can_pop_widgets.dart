import 'package:azrobot/core/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CanPopWidgets {
   void handleBackButton(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacement(AppRouter.kBersistentBottomNavBarView);
    }
  }
}