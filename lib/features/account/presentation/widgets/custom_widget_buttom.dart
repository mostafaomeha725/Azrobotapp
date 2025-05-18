import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomWidgetButtom extends StatelessWidget {
  const CustomWidgetButtom({
    super.key,
    this.onTap,
    required this.text,
    this.isExpired = false,
  });

  final void Function()? onTap;
  final String text;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonHeight = size.height * 0.06; // 6% of screen height
    final double fontSize = size.width * 0.04; // 4% of screen width

    return SizedBox(
      width: double.infinity,
      height: buttonHeight < 48 ? 48 : buttonHeight, // Minimum height = 48
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isExpired ? Colors.grey : const Color(0xff134FA2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isExpired ? null : onTap,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyles.bold14w500.copyWith(
              color: Colors.white,
              fontSize: fontSize < 14 ? 14 : fontSize, // Minimum font size = 14
            ),
          ),
        ),
      ),
    );
  }
}
