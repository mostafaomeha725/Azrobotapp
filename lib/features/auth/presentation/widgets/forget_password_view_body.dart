import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/Custom_buttom.dart';
import 'package:azrobot/core/widgets/custom_text_field.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetYourPasswordViewBody extends StatefulWidget {
  const ForgetYourPasswordViewBody({super.key, this.isLoading = false});

  final bool isLoading;
  @override
  State<ForgetYourPasswordViewBody> createState() =>
      _ForgetYourPasswordViewBodyState();
}

class _ForgetYourPasswordViewBodyState
    extends State<ForgetYourPasswordViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: widget.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(
          key: formKey, // Wrap the form fields with a Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text("Forget your password?", style: TextStyles.bold24w600),
              SizedBox(height: 16),
              Text(
                "Enter your Email address, and we will send you a reset password link",
                style: TextStyles.bold16w500.copyWith(color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              HintTextAuth(hint: "Email"),
              SizedBox(height: 8),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!value.contains("@")) {
                    return "Please enter a valid email address";
                  } else if (!value.endsWith(".com")) {
                    return "Please enter a valid email address";
                  } else if (!value.contains("gmail.com")) {
                    return "Please enter a valid Gmail address";
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 44),
              CustomButtom(
                text: "Send Code",
                onPressed: () {
                  GoRouter.of(context).push(AppRouter.kOtpCodeView);
                  // if (formKey.currentState!.validate()) {
                  //   formKey.currentState!.save();

                  // }
                },
                issized: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
