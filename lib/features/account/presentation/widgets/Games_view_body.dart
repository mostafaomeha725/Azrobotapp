import 'package:azrobot/features/games/manager/cubit/add_game_point_cubit/add_game_point_cubit.dart';
import 'package:azrobot/features/games/manager/cubit/get_games_cubit/get_games_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/features/account/presentation/widgets/games_card_widget.dart';

class GamesViewBody extends StatefulWidget {
  const GamesViewBody({super.key});

  @override
  State<GamesViewBody> createState() => _GamesViewBodyState();
}
class _GamesViewBodyState extends State<GamesViewBody> {
  final List<Map<String, dynamic>> fullGamesData = [
    {
      "id": 1,
      "games_name": "Memory Game",
      "image": "assets/memorygames.png",
      "route": AppRouter.kMemoryGamesView,
    },
    {
      "id": 2,
      "games_name": "XO Game",
      "image": "assets/xogames2.png",
      "route": AppRouter.kXoGamesView,
    },
    {
      "id": 3,
      "games_name": "Lucky Draw Games",
      "image": "assets/image/spinwheel.png",
      "route": AppRouter.kLuckyDrawSpinView,
    },
    {
      "id": 4,
      "games_name": "Slot Machine Games",
      "image": "assets/Graphics/slotmachine.png",
      "route": AppRouter.kSlotMachineGameView,
    },
  ];

  int? selectedGameId;
  String? selectedRoute;

  @override
  void initState() {
    super.initState();
    context.read<GetGamesCubit>().getGames();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddGamePointCubit, AddGamePointState>(
      listenWhen: (previous, current) =>
          current is AddGamePointSuccess || current is AddGamePointFailure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (selectedRoute != null) {
          GoRouter.of(context).push(selectedRoute!);
        }

        if (state is AddGamePointSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AddGamePointFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }

        // Reset after navigation
        selectedGameId = null;
        selectedRoute = null;
      },
      child: BlocBuilder<GetGamesCubit, GetGamesState>(
        builder: (context, state) {
          if (state is GetGamesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetGamesFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is GetGamesSuccess) {
            final visibleIds = state.games.map((game) => game['id'] as int).toSet();
            final visibleGames = fullGamesData.where((game) {
              return visibleIds.contains(game['id']);
            }).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double aspectRatio = constraints.maxWidth > 600 ? 0.65 : 0.80;
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: visibleGames.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final game = visibleGames[index];
                      return GamesCardWidget(
                        title: game["games_name"],
                        imagegames: game["image"],
                        gameId: game["id"],
                        onTap: () {
                          setState(() {
                            selectedGameId = game["id"];
                            selectedRoute = game["route"];
                          });
                          context.read<AddGamePointCubit>().addGamePoint(game["id"]);
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
