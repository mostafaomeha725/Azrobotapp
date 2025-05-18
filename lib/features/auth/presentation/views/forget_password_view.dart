import 'package:azrobot/features/auth/presentation/widgets/forget_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetYourPasswordView extends StatelessWidget {
  const ForgetYourPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_back_ios, color: Color(0xff134FA2)),
          ),
        ),
      ),
      body: ForgetYourPasswordViewBody(
          isLoading: false), // فقط واجهة المستخدم بدون المنطق
    );
  }
}
