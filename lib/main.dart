import 'dart:io';
import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/helper/BlocObserve/Simple_Bloc_Observe.dart';
import 'package:azrobot/core/helper/notification/schedula_reminder_notification.dart' as NotificationService;
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
import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/post_view_specific_content/cubit/viewspecificcontent_cubit.dart';
import 'package:azrobot/features/home/presentation/manager/cubits/purchase_vouchers/cubit/purchase_vouchers_cubit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void setupTimezone() {
  tzData.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
}

Future<void> requestPermissions() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    
    // طلب إذن الإشعارات
    if (androidInfo.version.sdkInt >= 33) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        status = await Permission.notification.request();
        print('🔔 حالة إذن الإشعارات: $status');
        if (!status.isGranted) {
          print('⚠️ إذن الإشعارات مرفوض، قد لا تظهر الإشعارات');
        }
      }
    }

    // طلب إذن SCHEDULE_EXACT_ALARM
    if (androidInfo.version.sdkInt >= 31) {
      var status = await Permission.scheduleExactAlarm.status;
      if (!status.isGranted) {
        status = await Permission.scheduleExactAlarm.request();
        print('🔔 حالة إذن الإنذارات الدقيقة: $status');
        if (!status.isGranted) {
          print('⚠️ إذن الإنذارات الدقيقة مرفوض، الإشعارات قد تتأخر');
        }
      }
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المنطقة الزمنية
  setupTimezone();

  // تهيئة الإشعارات
  await NotificationService.initNotifications();

  // طلب الأذونات
  await requestPermissions();

  // إلغاء كل الإشعارات القديمة لتجنب التعارض
  await flutterLocalNotificationsPlugin.cancelAll();
  print('🔔 تم إلغاء كل الإشعارات القديمة');

  // تهيئة Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderModelAdapter());
  await Hive.openBox<ReminderModel>('reminders');

  // جلب SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final password = prefs.getString('password');
  final email = prefs.getString('email');

  Bloc.observer = SimpleBlocObserve();

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
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(ApiService(), SharedPreference())..getProfile(),
        ),
        BlocProvider<GetallcityCubit>(
          create: (context) =>
              GetallcityCubit(ApiService(), SharedPreference())..getAllCity(),
        ),
        BlocProvider<GetallspecialtiesCubit>(
          create: (context) =>
              GetallspecialtiesCubit(ApiService(), SharedPreference())..getAllSpecialties(),
        ),
        BlocProvider<GetContentByCategoryCubit>(
          create: (context) =>
              GetContentByCategoryCubit(ApiService(), SharedPreference()),
        ),
        BlocProvider<GetAllContentsCubit>(
          create: (context) =>
              GetAllContentsCubit(ApiService(), SharedPreference())..getAllContents(),
        ),
        BlocProvider<GetVoucherCubit>(
          create: (context) => GetVoucherCubit(ApiService()),
        ),
        BlocProvider<PurchaseVouchersCubit>(
          create: (context) => PurchaseVouchersCubit(),
        ),
        BlocProvider<ViewspecificcontentCubit>(
          create: (context) => ViewspecificcontentCubit(),
        ),
        BlocProvider<ReminderCubit>(
          create: (context) => ReminderCubit(),
        ),
        BlocProvider<GetGamesCubit>(
          create: (context) => GetGamesCubit(dio: Dio()),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(
            ApiService(),
            ProfileCubit(ApiService(), SharedPreference()),
            SharedPreference(),
          )..signInUser(email: email ?? '', password: password ?? ''),
        ),
        BlocProvider<GetUserPointCubit>(
          create: (context) => GetUserPointCubit(ApiService()),
        ),
      ],
      child: const AzrobotApp(),
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
    );
  }
}