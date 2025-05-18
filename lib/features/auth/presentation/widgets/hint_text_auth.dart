import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class HintTextAuth extends StatelessWidget {
  const HintTextAuth({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          hint,
          style: TextStyles.bold16w400.copyWith(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
