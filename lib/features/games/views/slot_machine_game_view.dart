import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kprimarycolor = Color(0xffDD009F);
const ksecondarycolor = Color(0xff5C0051);
const kyellowcolor = Color(0xffFFC356);

class GameService {
  int yourcoins = 100;
  int highscore = 0;
  bool coin10 = true;
  var reels = [0, 1, 2];

  var items = [
    "gfx-bell.png",
    "gfx-cherry.png",
    "gfx-coin.png",
    "gfx-grape.png",
    "gfx-seven.png",
    "gfx-strawberry.png"
  ];

  spin() {
    var spinammount = coin10 ? 10 : 20;
    if (spinammount <= yourcoins) {
      reels = List.generate(3, (_) => Random().nextInt(items.length));
      if (reels[0] == reels[1] && reels[0] == reels[2]) {
        if (coin10) {
          yourcoins = yourcoins + 10 * 10;
        } else {
          yourcoins = yourcoins + 20 * 10;
        }
        if (yourcoins > highscore) {
          highscore = yourcoins;
        }

        return 'WIN';
      } else {
        if (coin10) yourcoins = yourcoins - 10;
        if (!coin10) yourcoins = yourcoins - 20;
        if (yourcoins <= 0) {
          return 'GAME END';
        }
      }
    } else {
      return 'GAME END';
    }
  }

  reset() {
    yourcoins = 100;
  }
}

class SlotMachineGameView extends StatefulWidget {
  const SlotMachineGameView({super.key});

  @override
  State<SlotMachineGameView> createState() => _SlotMachineGameViewState();
}

class _SlotMachineGameViewState extends State<SlotMachineGameView>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );

  late final AnimationController spinnercontroller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );

  var gameserivce = GameService();

  @override
  void initState() {
    super.initState();

    controller.forward();
    spinnercontroller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double resHeight = MediaQuery.of(context).size.height;
    double resWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kprimarycolor, ksecondarycolor])),
      child: Scaffold(
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
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: EdgeInsets.only(left: 15, right: 15),
          children: [
            SizedBox(
              height: resHeight * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gameserivce.reset();
                    });
                  },
                  child: const Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                Image.asset(
                  'assets/Graphics/gfx-slot-machine.png',
                  width: resWidth * 0.6,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                )
              ],
            ),
            SizedBox(
              height: resHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.25),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'YOUR\nCOINS',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        gameserivce.yourcoins.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.25),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        gameserivce.highscore.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'HIGH\nSCORE',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: resHeight * 0.02,
            ),
            Column(
              children: [
                spinnerwidgetbox(
                  spinnerImage: gameserivce.items[gameserivce.reels[0]],
                  isSpin: false,
                  controller: spinnercontroller,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    spinnerwidgetbox(
                      spinnerImage: gameserivce.items[gameserivce.reels[1]],
                      isSpin: false,
                      controller: spinnercontroller,
                    ),
                    spinnerwidgetbox(
                      spinnerImage: gameserivce.items[gameserivce.reels[2]],
                      isSpin: false,
                      controller: spinnercontroller,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    spinnercontroller.forward(from: 0);
                    var spin = gameserivce.spin();
                    if (spin == "GAME END") {
                      showPopup('GAME END');
                    }
                    if (spin == "WIN") {
                      showPopup('WIN');
                    }
                    setState(() {});
                  },
                  child: spinnerwidgetbox(
                    spinnerImage: 'gfx-spin.png',
                    isSpin: true,
                    controller: spinnercontroller,
                  ),
                )
              ],
            ),
            SizedBox(
              height: resHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gameserivce.coin10 = true;
                      controller.forward(from: 0);
                    });
                  },
                  child: CoinChangeWidget(
                    isTrue: gameserivce.coin10,
                    coinValue: '10',
                  ),
                ),
                Container(
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0, 0),
                            end: Offset(gameserivce.coin10 ? -2 : 2, 0))
                        .animate(controller),
                    child: Image.asset(
                      'assets/Graphics/gfx-casino-chips.png',
                      height: 40,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gameserivce.coin10 = false;
                      controller.forward(from: 0);
                    });
                  },
                  child: CoinChangeWidget(
                    isTrue: !gameserivce.coin10,
                    coinValue: '20',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  showPopup(type) {
    double resHeight = MediaQuery.of(context).size.height;
    double resWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            height: resHeight * 0.35,
            width: resWidth * 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Material(
                child: Column(
                  children: [
                    Container(
                      width: resWidth * 0.9,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight,
                              colors: [kprimarycolor, ksecondarycolor])),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            type == "GAME END" ? "GAME OVER" : "YOU WIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      'assets/Graphics/gfx-seven-reel.png',
                      width: 100,
                    ),
                    Spacer(),
                    Text(
                      type == "GAME END"
                          ? "Bad Luck! You lost all of the coins.\nLet's play again"
                          : "Hurray! You win the spin.\nLet's play again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 17),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          if (type == "GAME END") {
                            Navigator.pop(context);
                            setState(() {
                              gameserivce.reset();
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5)),
                            foregroundColor:
                                WidgetStateProperty.all(kprimarycolor),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: kprimarycolor, width: 3)))),
                        child: Text(
                          type == "GAME END" ? "NEW GAME" : "CONTINUE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        )),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CoinChangeWidget extends StatelessWidget {
  final bool isTrue;
  final String coinValue;
  const CoinChangeWidget(
      {super.key, required this.isTrue, required this.coinValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kprimarycolor, ksecondarycolor]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: kprimarycolor)),
      child: Center(
        child: Text(
          coinValue,
          style: TextStyle(
              color: isTrue ? kyellowcolor : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class spinnerwidgetbox extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final spinnerImage;
  // ignore: prefer_typing_uninitialized_variables
  final isSpin;
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  const spinnerwidgetbox(
      {super.key,
      required this.spinnerImage,
      required this.isSpin,
      required this.controller});

  @override
  State<spinnerwidgetbox> createState() => spinnerwidgetboxState();
}

// ignore: camel_case_types
class spinnerwidgetboxState extends State<spinnerwidgetbox>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double resWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: resWidth * 0.435,
      child: Stack(
        children: [
          Image.asset(
            'assets/Graphics/gfx-reel.png',
          ),
          SlideTransition(
            position: Tween<Offset>(
                    begin: Offset(0, !widget.isSpin ? -0.15 : 0),
                    end: Offset(0, 0))
                .animate(widget.controller),
            child: Image.asset('assets/Graphics/${widget.spinnerImage}'),
          )
        ],
      ),
    );
  }
}
