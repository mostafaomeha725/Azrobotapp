import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:wheel_spin/wheelspin.dart';

class LuckyDrawSpinView extends StatefulWidget {
  const LuckyDrawSpinView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LuckyDrawSpinViewState createState() => _LuckyDrawSpinViewState();
}

class _LuckyDrawSpinViewState extends State<LuckyDrawSpinView>
    with SingleTickerProviderStateMixin {
  final WheelSpinController wheelSpinController = WheelSpinController();
  int? winningSegment;
  bool isSpinning = false;
  bool showAnimation = false;
  late AnimationController _animationController;

  // Define your prizes here
  final List<String> prizes = [
    'iphone',
    'Car',
    'Watch',
    'Bike',
    'Gold Coin',
    'World Cup Ticket',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  void spinWheel() {
    setState(() {
      winningSegment = null;
      isSpinning = true;
      showAnimation = false;
    });
    wheelSpinController.startWheel();
  }

  void stopWheel() {
    setState(() {
      isSpinning = false;
      winningSegment = Random().nextInt(prizes.length);
      showAnimation = true;
    });
    wheelSpinController.stopWheel(2);

    if (showAnimation) {
      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          height: 40, // الحجم الذي تريده
          width: 40, // الحجم الذي تريده
          decoration: BoxDecoration(
            color: Color(0xFF0062CC), // اللون الأزرق
            borderRadius: BorderRadius.circular(10), // تحديد الحواف الدائرية
          ),
          child: IconButton(
            icon: Icon(
              Icons.chevron_left_sharp, // أيقونة العودة
              color: Colors.white, // لون الأيقونة الأبيض
              size: 24, // حجم الأيقونة
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: WheelSpin(
                  controller: wheelSpinController,
                  pathImage: 'assets/image/spinwheel.png',
                  withWheel: 300,
                  pieces: prizes.length,
                  isShowTextTest: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 350, left: 20),
                child: Image.asset('assets/image/arrow.jfif',
                    width: 50, height: 50),
              ),
              if (showAnimation)
                SizedBox(
                  width: 500, // Adjust size as needed
                  height: 500,
                  child: Lottie.asset(
                    'assets/animation/celebration.json',
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController.duration = composition.duration;
                      _animationController
                        ..reset()
                        ..forward();
                    },
                  ),
                ),
            ],
          ),
          if (!isSpinning && winningSegment != null)
            Text(
              'Congratulations! You won ${prizes[winningSegment!]}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: spinWheel,
            child: Container(
                width: 100,
                height: 45,
                decoration: ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Center(
                    child: Text(
                  "Start",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))),
          ),
          TextButton(
            onPressed: stopWheel,
            child: Center(
              child: Container(
                  width: 100,
                  height: 45,
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Center(
                      child: Text(
                    "Stop",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}
