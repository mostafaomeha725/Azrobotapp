import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTodayTips extends StatelessWidget {
  const CardTodayTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
        left: 25,
        right: 30,
        bottom: 16,
      ), // Margin around the card
      padding: const EdgeInsets.all(20), // Padding inside the card
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the card
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 10, // Shadow blur radius
            spreadRadius: 5, // How much the shadow spreads
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text("Today's Tip", style: TextStyles.bold20w600inter),
          SizedBox(height: 4),
          Text(
            "Walk barefoot on grass for a few minutes – it reduces stress, improves circulation, and boosts mood naturally.",
            style: TextStyles.bold16w400inter,
          ),
        ],
      ),
    );
  }
}
