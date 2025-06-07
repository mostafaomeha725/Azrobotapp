import 'dart:async';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reset_otp_cubit/reset_otp_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpCodeViewBody extends StatefulWidget {
  const OtpCodeViewBody({super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  // ignore: library_private_types_in_public_api
  _OtpCodeViewBodyState createState() => _OtpCodeViewBodyState();
}

class _OtpCodeViewBodyState extends State<OtpCodeViewBody> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  int _remainingTime = 120;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _verifyOTP(BuildContext context) async {
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 4-digit code")),
      );
      return;
    }

    context.read<VerifyOtpCubit>().verifyOtp(
          email: widget.email,
          otp: otp,
          context: context,
        );
  }

  void _resendOTP(BuildContext context) {
    setState(() {
      _remainingTime = 120;
    });

    _timer.cancel();
    _startTimer();

    context.read<ResetOtpCubit>().resetOtp(
          email: widget.email,
          context: context,
        );
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'OTP',
            style: TextStyles.bold30w600.copyWith(
              color: const Color(0xff134FA2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Enter verification code',
            style: TextStyles.bold20w500.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 24),
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (value.length == 1 && index < 3) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          // Timer and Resend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_remainingTime > 0)
                Text(
                  'Time Remaining ${_remainingTime}s',
                  style: TextStyles.bold16w400.copyWith(color: Colors.grey),
                ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _resendOTP(context),
                child: Text(
                  'Resend code',
                  style: TextStyles.bold16w600.copyWith(
                    decoration: TextDecoration.underline,
                    color: const Color(0xff134FA2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () => _verifyOTP(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: const Color(0xff134FA2),
              ),
              child: Text(
                'Verify',
                style: TextStyles.bold18w500.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),

          BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) async {
              if (state is VerifyOtpSuccess) {
                await context.read<SignInCubit>().signInUser(
                      email: widget.email,
                      password: widget.password,
                    );
                await Future.delayed(const Duration(milliseconds: 200));
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                await context.read<ProfileCubit>().getProfile();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("OTP verified successfully")),
                );
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                GoRouter.of(context).pushReplacement(AppRouter.kBersistentBottomNavBarView);
              } else if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is VerifyOtpLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocConsumer<ResetOtpCubit, ResetOtpState>(
            listener: (context, state) {
              if (state is ResetOtpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("New OTP sent successfully")),
                );
              } else if (state is ResetOtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is ResetOtpLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
