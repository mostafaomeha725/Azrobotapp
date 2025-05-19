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
      ),
      padding: const EdgeInsets.all(20), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1), 
            blurRadius: 10, 
            spreadRadius: 5, 
            offset: const Offset(0, 4), 
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
