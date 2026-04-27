import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            decoration: const PageDecoration(
                // imageFlex: 2,
                imagePadding: EdgeInsets.only(top: 30),
                bodyAlignment: Alignment.bottomCenter,
                imageAlignment: Alignment.center),
            title: "Welcome to Advertising",
            body: "Your journey to productivity starts here.",
            image: Center(
              child: Image.asset(
                'assets/images/onboarding1.jpg',
              ),
            ),
          ),
          PageViewModel(
            decoration: const PageDecoration(
                // imageFlex: 2,
                imagePadding: EdgeInsets.only(top: 30),
                bodyAlignment: Alignment.bottomCenter,
                imageAlignment: Alignment.center),
            title: "Stay Connected",
            body: "Engage with your community anytime, anywhere.",
            image: Center(
              child: Image.asset(
                'assets/images/onboarding2.jpg',
              ),
            ),
          ),
          PageViewModel(
            decoration: const PageDecoration(
                // imageFlex: 2,
                imagePadding: EdgeInsets.only(top: 30),
                bodyAlignment: Alignment.bottomCenter,
                imageAlignment: Alignment.center),
            title: "Achieve Your Goals",
            body: "Tools and insights to help you succeed.",
            image: Center(
              child: Image.asset(
                'assets/images/onboarding3.jpg',
              ),
            ),
          ),
        ],
        onDone: () {
          Get.toNamed('/SignInScreen');
        },
        onSkip: () {
          // Skip the onboarding and go directly to home screen
          Get.toNamed('/SignInScreen');
        },
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
