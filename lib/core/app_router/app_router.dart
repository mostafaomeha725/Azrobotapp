import 'package:azrobot/features/account/presentation/views/games_view.dart';
import 'package:azrobot/features/auth/presentation/views/forget_password_view.dart';
import 'package:azrobot/features/auth/presentation/views/login_view.dart';
import 'package:azrobot/features/auth/presentation/views/otp_code_view.dart';
import 'package:azrobot/features/auth/presentation/views/signup_view.dart';
import 'package:azrobot/features/games/views/Lucky_draw_spin_view.dart';
import 'package:azrobot/features/games/views/XO_game_view.dart';
import 'package:azrobot/features/games/views/memory_game_view.dart';
import 'package:azrobot/features/games/views/slot_machine_game_view.dart';
import 'package:azrobot/features/home/presentation/views/Bersistent_Bottom_NavBar_View.dart';
import 'package:azrobot/features/home/presentation/views/life_style_details_view.dart';
import 'package:azrobot/features/home/presentation/views/life_style_view.dart';
import 'package:azrobot/features/home/presentation/views/medical_hub_details_view.dart';
import 'package:azrobot/features/home/presentation/views/medical_hub_view.dart';
import 'package:azrobot/features/home/presentation/views/news_feed_view.dart';
import 'package:azrobot/features/home/presentation/views/promote_clinic_details_view.dart';
import 'package:azrobot/features/home/presentation/views/promote_clinic_view.dart';
import 'package:azrobot/features/home/presentation/views/reminders_view.dart';
import 'package:azrobot/features/home/presentation/views/video_details_view.dart';
import 'package:azrobot/features/on_boarding/view/offer_history_view.dart';
import 'package:azrobot/features/on_boarding/view/onboarding_view.dart';
import 'package:azrobot/features/splash/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kSplashView = '/Splashview';
  static const kOnboardingView = '/Onboardingview';
  static const kSignUpView = '/SignUpView';
  static const kLoginView = '/LoginView';
  static const kForgetPasswordView = '/ForgetPasswordView';
  static const kOtpCodeView = '/OtpCodeView';
  static const kBersistentBottomNavBarView = '/BersistentBottomNavBarView';
  static const kMedicalHubView = '/MedicalHubView';
  static const kMedicalHubDetailsView = '/MedicalHubDetailsView';
  static const kPromoteClinicView = '/PromoteClinicView';
  static const kPromoteClinicDetailsView = '/PromoteClinicDetailsView';
  static const kLifeStyleView = '/LifeStyleView';
    static const kNewsFeed = '/NewsFeedView';
  static const kLifeStyleDetailsView = '/LifeStyleDetailsView';
  static const kVideoDetailsView = '/VideoDetailsView';

  static const kOfferHistoryView = '/OfferHistoryView';
  static const kRemindersView = '/RemindersView';
  static const kXoGamesView = '/XoGamesView';
  static const kMemoryGamesView = '/MemoryGamesView';
  static const kLuckyDrawSpinView = '/LuckyDrawSpinView';
  static const kSlotMachineGameView = '/SlotMachineGameView';
  static const kGamesView = '/GamesView';

  static GoRouter getRouter(String initialRoute) {
    return GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(path: kSplashView, builder: (context, state) => SplashView()),
        GoRoute(
          path: kOnboardingView,
          builder: (context, state) => OnboardingView(),
        ),
        GoRoute(
          path: kSignUpView,
          builder: (context, state) => SignUpView(),
        ),
        GoRoute(
          path: kLoginView,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: kForgetPasswordView,
          builder: (context, state) => const ForgetYourPasswordView(),
        ),
        GoRoute(
          path: kOtpCodeView,
          builder: (context, state) {
            final email = state.extra as String;
            return OtpCodeView(
              email: email,
            );
          },
        ),
        GoRoute(
          path: kBersistentBottomNavBarView,
          builder: (context, state) => BersistentBottomNavBarView(),
        ),
        GoRoute(
          path: kMedicalHubView,
          builder: (context, state) => MedicalHubView(),
        ),
        GoRoute(
          path: kMedicalHubDetailsView,
          pageBuilder: (context, state) {
            final item = state.extra as Map<String, dynamic>;
            return MaterialPage(
              child: MedicalHubDetailsView(item: item),
            );
          },
        ),
        GoRoute(
          path: kVideoDetailsView,
          pageBuilder: (context, state) {
            final item = state.extra as Map<String, dynamic>;
            return MaterialPage(
              child: VideoDetailsView(item: item),
            );
          },
        ),
        GoRoute(
          path: kPromoteClinicView,
          builder: (context, state) => PromoteClinicView(),
        ),
        GoRoute(
          path: kPromoteClinicDetailsView,
          pageBuilder: (context, state) {
            final item = state.extra as Map<String, dynamic>;
            return MaterialPage(
              child: PromoteClinicDetailsView(item: item),
            );
          },
        ),
        GoRoute(
          path: kLifeStyleView,
          builder: (context, state) => LifeStyleView(),
        ),
         GoRoute(
          path: kNewsFeed,
          builder: (context, state) => NewsFeedView(),
        ),
        GoRoute(
          path: kLifeStyleDetailsView,
          pageBuilder: (context, state) {
            final item = state.extra as Map<String, dynamic>;
            return MaterialPage(
              child: LifeStyleDetailsView(item: item),
            );
          },
        ),
        GoRoute(
          path: kOfferHistoryView,
          builder: (context, state) => OfferHistoryView(),
        ),
        GoRoute(
          path: kRemindersView,
          builder: (context, state) => RemindersView(),
        ),
        GoRoute(
          path: kMemoryGamesView,
          builder: (context, state) => MemoryGameView(),
        ),
        GoRoute(
          path: kXoGamesView,
          builder: (context, state) => XoGameView(),
        ),
        GoRoute(
          path: kLuckyDrawSpinView,
          builder: (context, state) => LuckyDrawSpinView(),
        ),
        GoRoute(
          path: kSlotMachineGameView,
          builder: (context, state) => SlotMachineGameView(),
        ),
          GoRoute(
          path: kGamesView,
          builder: (context, state) => GamesView(),
        ),
      ],
    );
  }
}
