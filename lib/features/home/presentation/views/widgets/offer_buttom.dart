import 'package:azrobot/core/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OfferButtom extends StatelessWidget {
  const OfferButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push(AppRouter.kOfferHistoryView);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("View Offers", style: TextStyle(color: Colors.white)),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
