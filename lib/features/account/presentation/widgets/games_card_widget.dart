import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class GamesCardWidget extends StatelessWidget {
  const GamesCardWidget(
      {super.key, required this.title, required this.imagegames});
  final String title;
  final String imagegames;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              // ignore: deprecated_member_use
              color: Color(0xFF0062CC).withOpacity(0.8),
              width: 2),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagegames,
            width: 140,
          ),
          Text(
            title,
            style: TextStyles.bold16w600.copyWith(color: Color(0xff44ded1)),
          )
        ],
      ),
    );
  }
}
