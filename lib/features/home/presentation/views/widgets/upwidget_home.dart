import 'package:azrobot/features/home/presentation/views/widgets/safeare_home.dart';
import 'package:flutter/material.dart';

class UpwidgetHome extends StatefulWidget {
  const UpwidgetHome({super.key, required this.point});
final String point ;

  @override
  State<UpwidgetHome> createState() => _UpwidgetHomeState();
}

class _UpwidgetHomeState extends State<UpwidgetHome> {
  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    final double headerHeight =
        size.height * 0.35; // Make header height 35% of screen height

    return Stack(
      children: [
        // Blue header background with responsive height
        Container(
          height: headerHeight, // Adjusted to be responsive
          decoration: BoxDecoration(
            color: const Color(0xFF0062CC),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        SafeareHome(
          point: widget.point,
        ), // Your SafeareHome widget stays as it is
        // You can add more widgets here for content
      ],
    );
  }
}
