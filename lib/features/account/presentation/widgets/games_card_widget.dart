import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/games/manager/cubit/add_game_point_cubit/add_game_point_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesCardWidget extends StatelessWidget {
  const GamesCardWidget({
    super.key,
    required this.title,
    required this.imagegames,
    required this.gameId,
    required this.onTap,
  });

  final String title;
  final String imagegames;
  final int gameId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF0062CC).withOpacity(0.8),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                imagegames,
                width: isTablet ? 160 : 120,
                height: isTablet ? 120 : 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.bold16w600.copyWith(
                fontSize: isTablet ? 18 : 14,
                color: const Color(0xff44ded1),
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<AddGamePointCubit, AddGamePointState>(
              builder: (context, state) {
                final cubit = context.read<AddGamePointCubit>();
                final isLoading = state is AddGamePointLoading &&
                    gameId == cubit.currentGameId;

                return isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
