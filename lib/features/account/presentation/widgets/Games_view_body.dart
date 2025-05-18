import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/features/account/presentation/widgets/games_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesViewBody extends StatefulWidget {
  const GamesViewBody({super.key});

  @override
  State<GamesViewBody> createState() => _GamesViewBodyState();
}

class _GamesViewBodyState extends State<GamesViewBody> {
  final List<Map<String, dynamic>> games = [
    {
      "games_name": "Memory Game",
      "image": "assets/memorygames.png",
      "route": AppRouter.kMemoryGamesView, // Add the route for each game
    },
    {
      "games_name": "XO Game",
      "image": "assets/xogames2.png",
      "route": AppRouter.kXoGamesView, // Add the route for each game
    },
    {
      "games_name": "Lucky Draw Games",
      "image": "assets/image/spinwheel.png",
      "route": AppRouter.kLuckyDrawSpinView, // Add the route for each game
    },
    {
      "games_name": "Slot Machine Games",
      "image": 'assets/Graphics/slotmachine.png',
      "route": AppRouter.kSlotMachineGameView, // Add the route for each game
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth > 600 ? 0.65 : 0.80;
          return GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: games.length, // Use games.length
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final game = games[index]; // Access the individual game
              return GestureDetector(
                onTap: () {
                  // Navigate to the corresponding page based on the route
                  GoRouter.of(context).push(game["route"]);
                },
                child: GamesCardWidget(
                  title: games[index]["games_name"],
                  imagegames: games[index]["image"],

                  // Pass the game image dynamically
                ),
              );
            },
          );
        },
      ),
    );
  }
}
