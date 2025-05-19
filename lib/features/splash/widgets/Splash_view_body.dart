import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }



Future<void> _navigateToNextScreen() async {
  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  await Future.delayed(const Duration(seconds: 3));

  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pushReplacement(AppRouter.kOnboardingView);
    return; // عشان يوقف هنا وما ينفذ الباقي
  }
    String? token = await SharedPreference().getToken();

 

  if (token == null) {
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
  } else {
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pushReplacement(AppRouter.kBersistentBottomNavBarView);
  }
}


  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset(Assets.assetsazrobotlogo, width: 250)],
      ),
    );
  }
}
