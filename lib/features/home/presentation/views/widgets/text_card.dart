import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "So close!",
          style: TextStyles.bold18w500.copyWith(color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          "More use, more points, more wins!",
          style: TextStyles.bold12w400.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
