import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemoryGameView extends StatefulWidget {
  const MemoryGameView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MemoryGameViewState createState() => _MemoryGameViewState();
}

class _MemoryGameViewState extends State<MemoryGameView> {
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  final Game _game = Game();

  // Game stats
  int tries = 0;
  int score = 0;
  bool gameOver = false; // Track game status

  @override
  void initState() {
    super.initState();
    _game.initGame();
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
        backgroundColor: Color(0xFFE55870),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE55870),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Memory Game",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              info_card("Tries", "$tries"),
              info_card("Score", "$score"),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
                itemCount: _game.gameImg.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: gameOver
                        ? null // Disable taps if game is over
                        : () {
                            setState(() {
                              tries++;
                              _game.gameImg[index] = _game.cardsList[index];
                              _game.matchCheck
                                  .add(index); // store index of tapped card
                              if (_game.matchCheck.length == 2) {
                                if (_game.gameImg[_game.matchCheck[0]] ==
                                    _game.gameImg[_game.matchCheck[1]]) {
                                  // Match found
                                  score += 100;
                                  _game.matchCheck.clear();
                                  // Check if all pairs are matched
                                  if (_game.gameImg.every(
                                      (img) => img != _game.hiddenCardPath)) {
                                    gameOver =
                                        true; // End game if all pairs matched
                                    _showEndGameDialog();
                                  }
                                } else {
                                  // No match, reset after a delay
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    setState(() {
                                      _game.gameImg[_game.matchCheck[0]] =
                                          _game.hiddenCardPath;
                                      _game.gameImg[_game.matchCheck[1]] =
                                          _game.hiddenCardPath;
                                      _game.matchCheck.clear();
                                    });
                                  });
                                }
                              }
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB46A),
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(_game.gameImg[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  // Display end game dialog
  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over!'),
          content: Text("Congratulations! You've matched all pairs!"),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  // Reset game
                  _game.initGame();
                  tries = 0;
                  score = 0;
                  gameOver = false; // Reset game over flag
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class Game {
  final Color hiddenCard = Colors.red;
  List<String> gameImg = [];
  List<String> cardsList = [
    "assets/images/circle.png",
    "assets/images/triangle.png",
    "assets/images/circle.png",
    "assets/images/heart.png",
    "assets/images/star.png",
    "assets/images/triangle.png",
    "assets/images/star.png",
    "assets/images/heart.png",
  ];
  final String hiddenCardPath = "assets/images/hidden.png";
  List<int> matchCheck = [];

  // Initialize the game state
  void initGame() {
    gameImg = List.generate(cardsList.length, (index) => hiddenCardPath);
  }
}

// ignore: non_constant_identifier_names
Widget info_card(String title, String info) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(26.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 26.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            info,
            style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
