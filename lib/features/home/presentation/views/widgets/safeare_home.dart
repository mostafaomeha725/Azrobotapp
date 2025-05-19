import 'package:azrobot/features/home/presentation/manager/cubits/get_user_point/cubit/getuserpoint_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/views/widgets/logo_number.dart';
import 'package:azrobot/features/home/presentation/views/widgets/offer_buttom.dart';
import 'package:azrobot/features/home/presentation/views/widgets/text_card.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeareHome extends StatefulWidget {
  const SafeareHome({super.key, this.isPlaying = false});
  final bool isPlaying;

  @override
  State<SafeareHome> createState() => _SafeareHomeState();
}

class _SafeareHomeState extends State<SafeareHome> {
  final double _maxPoints = 1000;
  double _points = 0; 

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchPoints();
  }

  Future<void> _loadUserIdAndFetchPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null && mounted) {
      context.read<GetUserPointCubit>().getUserPoints(userId);
    } else {
      debugPrint('No userId found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUserPointCubit, GetUserPointState>(
      listener: (context, state) {
        if (state is GetUserPointFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        // تحديث النقاط عند تلقي حالة ناجحة
        if (state is GetUserPointSuccess) {
          _points = state.points.toDouble();
        }

        final size = MediaQuery.of(context).size;
        final double horizontalPadding = size.width * 0.04;
        final double verticalSpacing = size.height * 0.02;
        final double logoSize = size.width * 0.08;
        final double progressCardPadding = size.width * 0.05;
        final double fontSizeLarge = size.width * 0.08;
        final double fontSizeMedium = size.width * 0.045;

        double progress = _points / _maxPoints;
        double barWidth = size.width - 2 * horizontalPadding;

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: verticalSpacing),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: logoSize / 2),
                    widget.isPlaying
                        ? const SizedBox()
                        : Image.asset(
                            Assets.assetsazrobotlogo,
                            height: logoSize,
                            color: Colors.white,
                          ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.015),
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kGamesView);
                          },
                          child: Icon(
                            Icons.sports_esports,
                            color: const Color(0xFF0062CC),
                            size: size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing * 1.5),
              widget.isPlaying
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Assets.assetsazrobotlogoonly,
                              height: logoSize,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              _points.toInt().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSizeLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Text(
                            "Azro Points",
                            style: TextStyles.bold18w500.copyWith(
                              color: Colors.white,
                              fontSize: fontSizeMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: Text(
                              "Azro Points",
                              style: TextStyles.bold18w500.copyWith(
                                color: Colors.white,
                                fontSize: fontSizeMedium,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: verticalSpacing / 2.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Assets.assetsazrobotlogoonly,
                                    height: logoSize,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    _points.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSizeLarge * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: horizontalPadding),
                              child: const OfferButtom(),
                            ),
                          ],
                        ),
                      ],
                    ),
              SizedBox(height: verticalSpacing),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xff41d5c5),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(progressCardPadding),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 0),
                                overlayShape: SliderComponentShape.noOverlay,
                                activeTrackColor: const Color(0xFF0062CC),
                                inactiveTrackColor: Colors.white,
                              ),
                              child: Slider(
                                value: _points,
                                min: 0,
                                max: _maxPoints,
                                onChanged: (value) {
                                  setState(() {
                                    _points = value;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              left: (barWidth * progress) - 30,
                              top: 12,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0062CC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.assetsazrobotlogoonly,
                                      height: size.width * 0.035,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      _points.toInt().toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSizeMedium * 0.9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalSpacing + 20),
                        const LogoNumber(),
                        SizedBox(height: verticalSpacing / 2),
                        const TextCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}