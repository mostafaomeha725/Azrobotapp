import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/helper/BlocObserve/Simple_Bloc_Observe.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/account/data/note_model.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_city_cubit/getallcity_cubit.dart';

import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_spe_cialties_cubits/cubit/getallspecialties_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reset_otp_cubit/reset_otp_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:azrobot/features/games/manager/cubit/get_games_cubit/get_games_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_all_content/cubit/get_all_contents_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_all_vouchers/cubit/get_voucher_cubits_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/get_content_category/getcontentcategory_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/purchase_vouchers/cubit/purchase_vouchers_cubit.dart';

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
    await Hive.initFlutter(); // تهيئة Hive مع Flutter
    Hive.registerAdapter(ReminderModelAdapter()); // سجل الأدابتور
    await Hive.openBox<ReminderModel>('reminders'); // ✅ افتح الصندوق هنا

  Bloc.observer = SimpleBlocObserve();
      final prefs = await SharedPreferences.getInstance();
     final password = prefs.getString('password');
     final email = prefs.getString('email');
     print(email);
   // Optional, for custom bloc observing
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(apiService: ApiService()),
        ),
        BlocProvider<VerifyOtpCubit>(
          create: (context) => VerifyOtpCubit(ApiService()),
        ),
        BlocProvider<ResetOtpCubit>(
          create: (context) => ResetOtpCubit(ApiService()),
        ),
        // Add more providers here if needed
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(ApiService(), SharedPreference())..getProfile(),
        ),
        BlocProvider<GetallcityCubit>(
          create: (context) =>
              GetallcityCubit(ApiService(), SharedPreference())..getAllCity(),
        ),
        BlocProvider<GetallspecialtiesCubit>(
          create: (context) =>
              GetallspecialtiesCubit(ApiService(), SharedPreference())
                ..getAllSpecialties(), // Trigger initial fetch
        ),
        BlocProvider<GetContentByCategoryCubit>(
            create: (context) =>
                GetContentByCategoryCubit(ApiService(), SharedPreference())),
        BlocProvider<GetAllContentsCubit>(
          create: (context) =>
              GetAllContentsCubit(ApiService(), SharedPreference())
                ..getAllContents(),
        ),
         BlocProvider<GetVoucherCubit>(
          create: (context) =>
              GetVoucherCubit(ApiService())
               
        ),
          BlocProvider<PurchaseVouchersCubit>(
          create: (context) =>
              PurchaseVouchersCubit()
               
        ),
         BlocProvider<ViewspecificcontentCubit>(
          create: (context) =>
              ViewspecificcontentCubit()
               
        ),
         BlocProvider<ReminderCubit>(
          create: (context) =>
              ReminderCubit()
               
        ),
 BlocProvider<GetGamesCubit>(
          create: (context) =>
              GetGamesCubit(dio: Dio())
               
        ),

           BlocProvider<SignInCubit>(
          create: (context) =>
              SignInCubit(
                ApiService(),
                ProfileCubit(ApiService(), SharedPreference(),
                
                ),
                SharedPreference()
              )..signInUser(email:email! , password:password! ),
               
        ),
      ],
      child: AzrobotApp(), 
    ),
  );
}


class AzrobotApp extends StatelessWidget {
  const AzrobotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      routerConfig: AppRouter.getRouter(AppRouter.kSplashView),
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}

