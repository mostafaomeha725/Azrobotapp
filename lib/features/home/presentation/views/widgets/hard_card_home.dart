import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class HardCardHome extends StatelessWidget {
  const HardCardHome({
    super.key,
    this.onTap,
    required this.image,
    required this.text,
  });

  final void Function()? onTap;
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: screenWidth,
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF40D4C9),
                Color(0xFF40D4C9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image, 

                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(text,
                  style: TextStyles.bold22w600.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
