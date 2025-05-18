import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kForgetPasswordView);
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Forget your Password ?",
            style: TextStyles.bold14w400.copyWith(color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }
}
