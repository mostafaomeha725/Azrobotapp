import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ScorePointWidgets extends StatelessWidget {
  const ScorePointWidgets({super.key, this.isExpired = false, required this.point});
  final bool isExpired;
  final String point ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: isExpired ? Colors.grey : Color(0xff45dfca),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              SizedBox(width: 4),
              Icon(
                Icons.stars,
                color: Colors.white,
                size: 16,
              ), // Icon color can be adjusted
              SizedBox(width: 6),
              Text(
                "$point points",
                style: TextStyles.bold12w400inter.copyWith(
                  color: Colors.white,
                ), // Adjust text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
