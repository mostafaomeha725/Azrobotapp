import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/account/presentation/widgets/account_view_body.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_out_cubit/cubit/sign_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(
            ApiService(),
            ProfileCubit(
              ApiService(),
              SharedPreference(),
            ),
            SharedPreference(),
          ),
        ),
        BlocProvider<SignOutCubit>(
          create: (context) => SignOutCubit(
            apiService: ApiService(),
            sharedPreference: SharedPreference(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.1),
        body: const AccountViewBody(),
      ),
    );
  }
}