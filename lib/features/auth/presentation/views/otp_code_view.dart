import 'package:azrobot/features/auth/presentation/widgets/otp_code_view_body.dart';
import 'package:flutter/material.dart';

class OtpCodeView extends StatelessWidget {
  const OtpCodeView({super.key, required this.email});
  final String email;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpCodeViewBody(
        email: email,
      ),
    );
  }
}
