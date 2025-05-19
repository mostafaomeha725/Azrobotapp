import 'package:azrobot/features/home/presentation/views/widgets/safeare_home.dart';
import 'package:flutter/material.dart';

class UpwidgetHome extends StatefulWidget {
  const UpwidgetHome({super.key});

  @override
  State<UpwidgetHome> createState() => _UpwidgetHomeState();
}

class _UpwidgetHomeState extends State<UpwidgetHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double headerHeight =
        size.height * 0.35; 

    return Stack(
      children: [
        
        Container(
          height: headerHeight, 
          decoration: BoxDecoration(
            color: const Color(0xFF0062CC),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        SafeareHome(
        ), 
      ],
    );
  }
}
