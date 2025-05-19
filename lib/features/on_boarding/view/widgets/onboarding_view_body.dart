import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/Custom_buttom.dart';
import 'package:azrobot/features/on_boarding/view/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
    initialPage: 0,
  );

  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": Assets.assetsdentistry,
      "text":
          "Access tips and tricks from trusted sources to promote your clinic and enhance patient care",
    },
    {
      "image": Assets.assetsfood,
      "text":
          "Explore educational content, earn points, and unlock rewards tailored for your expertise.",
    },

    {
      "image": Assets.assetsbackgrounditemonboarding2,
      "text":
          "Stay updated on Azrobot, earn points, and redeem rewards—all in one app designed for you.",
    },
  ];

  void _handleNext() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: onboardingData.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final data = onboardingData[index];
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = (_pageController.page! - index).abs();
                  value = (1 - (value * 0.3)).clamp(0.8, 1.5);
                }

                final double verticalTranslation = (1 - value) * 30;

                return Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, verticalTranslation)
                        ..scale(0.9, value),
                  child: Align(
                    alignment:
                        Alignment
                            .center, // Align the image to the center of the screen
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 125),
                      child: OnboardingPage(image: data['image']!),
                    ),
                  ),
                );
              },
            );
          },
        ),

        // Skip Button
        Positioned(
          top: 60,
          right: 20,
          child: TextButton(
            onPressed: () {
             GoRouter.of(context).pushReplacement(AppRouter.kSignUpView);
            },
            child: Text(
              "Skip",
              style: TextStyles.bold16w500.copyWith(
                color: const Color(0xFF134FA2),
              ),
            ),
          ),
        ),

        // Dot Indicator
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardingData.length,
              effect: JumpingDotEffect(
                dotColor: Colors.grey,
                activeDotColor: const Color(0xFF134FA2),
                dotHeight: 10,
                dotWidth: 10,
              ),
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 160,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              onboardingData[_currentIndex]['text']!,
              textAlign: TextAlign.center,
              style: TextStyles.bold18w600.copyWith(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
        ),
        // Next / Get Started Button
        Positioned(
          bottom: 70,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButtom(text: "Next", onPressed: _handleNext),
          ),
        ),
      ],
    );
  }
}
