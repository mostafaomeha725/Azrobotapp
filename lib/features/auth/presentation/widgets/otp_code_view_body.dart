import 'dart:async';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';

import 'package:azrobot/features/auth/presentation/manager/cubits/reset_otp_cubit/reset_otp_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpCodeViewBody extends StatefulWidget {
  const OtpCodeViewBody({super.key, required this.email});
  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _OtpCodeViewBodyState createState() => _OtpCodeViewBodyState();
}

class _OtpCodeViewBodyState extends State<OtpCodeViewBody> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  int _remainingTime = 120; // 2 minutes countdown
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Function to start the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  // Function to handle OTP submission
  void _verifyOTP(BuildContext context) {
    String otp = _controllers.map((controller) => controller.text).join();
    print(otp);

    context.read<VerifyOtpCubit>().verifyOtp(
          email: widget.email,
          otp: otp,
          context: context,
        );
  }

  // Function to handle resend OTP
  void _resendOTP(BuildContext context) {
    context.read<ResetOtpCubit>().resetOtp(
          email: widget.email,
          context: context,
        );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'OTP',
            style: TextStyles.bold30w600.copyWith(
              color: Color(0xff134FA2),
            ),
          ),
          SizedBox(height: 20),
          // OTP Title
          Text(
            'Enter verification code',
            style: TextStyles.bold20w500.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 20),
          // OTP Input Fields (changed from 6 to 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
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
          SizedBox(height: 30),
          // Timer and Resend OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Time Remaining ${_remainingTime}s',
                  style: TextStyles.bold16w400.copyWith(color: Colors.grey)),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _resendOTP(context), // Trigger resend OTP
                child: Text(
                  'Resend code',
                  style: TextStyles.bold16w600.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 70),
          // Verify Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () => _verifyOTP(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Color(0xff134FA2),
              ),
              child: Text(
                'Verify',
                style: TextStyles.bold18w500.copyWith(color: Colors.white),
              ),
            ),
          ),
          BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (state is VerifyOtpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("OTP verified successfully")),
                );
                GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
              } else if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is VerifyOtpLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
          // Reset OTP State Listener
          BlocConsumer<ResetOtpCubit, ResetOtpState>(
            listener: (context, state) {
              if (state is ResetOtpLoading) {
                // Optionally show loading indicator for OTP reset
              } else if (state is ResetOtpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("New OTP sent successfully")),
                  // Show success message
                );
              } else if (state is ResetOtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.errMessage)), // Show error message
                );
              }
            },
            builder: (context, state) {
              if (state is ResetOtpLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
