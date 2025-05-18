import 'package:azrobot/core/app_router/app_router.dart';

import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/widgets/Custom_buttom.dart';
import 'package:azrobot/core/widgets/custom_text_field.dart';
import 'package:azrobot/features/auth/presentation/widgets/forget_password_text.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:azrobot/features/auth/presentation/widgets/login_text.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // Default email
    String? password; // Default password

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 70),
              Image.asset(
                Assets.assetsazrobotlogo,
                width: 250,
                height: 200,
              ),
              const HintTextAuth(hint: "Email"),
              const SizedBox(height: 6),
              CustomTextField(
                onSaved: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!value.contains("@") || !value.endsWith(".com")) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const HintTextAuth(hint: "Password"),
              const SizedBox(height: 6),
              CustomTextField(
                onSaved: (value) {password = value;
                
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                active: true,
              ),
              const SizedBox(height: 12),
              const ForgetPasswordText(),
              const SizedBox(height: 24),
              BlocConsumer<SignInCubit, SignInState>(
                listener: (context, state) async {
                  if (state is SignInLoading) {
                    // Show loading dialog or indicator if needed
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is SignInSuccess) {
                       final prefs = await SharedPreferences.getInstance();
      await prefs.setString("password", password!);
await Future.delayed(const Duration(milliseconds: 200));
                    GoRouter.of(context)
                        .pushReplacement(AppRouter.kBersistentBottomNavBarView);
                  } else if (state is SignInFailure) {


GoRouter.of(context).pop();
  if (state.errMessage.contains("Please verify your email first")) {
    GoRouter.of(context).go(AppRouter.kOtpCodeView,extra: email);
  } else {
    // Show an error dialog or snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errMessage)),
    );
  }
}
                },
                builder: (context, state) {
                  return CustomButtom(
                    text: "Login",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // Trigger the login process with cubit
                        await context.read<SignInCubit>().signInUser(
                              email: email!,
                              password: password!,
                            );
                            await Future.delayed(const Duration(milliseconds: 200));
                        // ignore: use_build_context_synchronously
                        await context.read<ProfileCubit>().getProfile();
                        

                      }
                    },
                    issized: false,
                  );
                },
              ),
              const SizedBox(height: 48),
              LoginText(
                text: "Don’t have an account?  ",
                textClick: "SignUp",
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kSignUpView);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 String? email;