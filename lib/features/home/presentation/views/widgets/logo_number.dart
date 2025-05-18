import 'package:azrobot/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class LogoNumber extends StatelessWidget {
  const LogoNumber({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(Assets.assetsazrobotlogoonly, height: 18),
            SizedBox(width: 4),
            Text("0", style: TextStyle(color: Colors.white)),
          ],
        ),
        Text("1,000", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
