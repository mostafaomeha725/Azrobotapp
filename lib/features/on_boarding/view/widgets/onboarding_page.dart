import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;

  const OnboardingPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        image,
        width:
            MediaQuery.of(context).size.width *
            0.8, // Adjust width relative to the screen size
        height:
            MediaQuery.of(context).size.height *
            0.5, // Adjust height relative to the screen size
        fit:
            BoxFit
                .cover, // Ensures the image covers the space while maintaining its aspect ratio
      ),
    );
  }
}
