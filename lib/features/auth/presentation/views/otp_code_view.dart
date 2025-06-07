import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reset_otp_cubit/reset_otp_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:azrobot/features/auth/presentation/widgets/otp_code_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCodeView extends StatelessWidget {
  const OtpCodeView({super.key, required this.email, required this.password});
  
  final String email;
  final String password;
@override
Widget build(BuildContext context) {
  print('Email: $email');
  print('Password: $password');

  return  MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => SignInCubit(ApiService(),ProfileCubit(ApiService(), SharedPreference(),),SharedPreference()),),
    BlocProvider(create: (_) => ProfileCubit(
      ApiService(),SharedPreference(),
    )),
    BlocProvider(create: (_) => VerifyOtpCubit(
      ApiService(),
    )),
    BlocProvider(create: (_) => ResetOtpCubit(
ApiService()
    ),),
  ],
  child: Scaffold(
    body: OtpCodeViewBody(
      email: email,
      password: password,
    ),
  ),
);

}
}