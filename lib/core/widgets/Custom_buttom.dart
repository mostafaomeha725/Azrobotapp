import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    this.onPressed,
    required this.text,
    this.issized = false,
  });
  final void Function()? onPressed;
  final String text;
  final bool issized;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff134FA2),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Text(
          text,
          style:
              issized
                  ? TextStyles.bold20w600.copyWith(color: Colors.white)
                  : TextStyles.bold16w500.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
