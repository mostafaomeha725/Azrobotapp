import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:azrobot/features/auth/presentation/widgets/login_view_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(ApiService(),
          ProfileCubit(ApiService(), SharedPreference()), SharedPreference()),
      child: Scaffold(body: LoginViewBody()),
    );
  }
}
