import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppbarTextWidget extends StatelessWidget {
  const AppbarTextWidget({super.key, required this.text, this.onTap});
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyles.bold18w500),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                "view all",
                style: TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
