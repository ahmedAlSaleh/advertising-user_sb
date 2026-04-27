import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<List<Color>> _gradientColors = [
    [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
    [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
    [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
    [const Color(0xFFFF6B95), const Color(0xFFFFC796)],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutQuart,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors[_currentPage],
        ),
      ),
      child: SafeArea(
        child: IntroductionScreen(
          onChange: (index) {
            setState(() {
              _currentPage = index;
              _animationController.reset();
              _animationController.forward();
            });
          },
          pages: [
            _buildPage('assets/lottie/dddd.json', "Discover Amazing Offers".tr,
                "Browse exclusive deals and special promotions tailored just for you. Stay updated with the latest offers from your favorite stores.".tr),
            _buildPage('assets/lottie/bbbb.json', "Find What You Need".tr,
                "Search for the perfect deal that matches your needs. Filter by price, category, or location to find stores near you.".tr),
            _buildPage('assets/lottie/cccc.json', "Track Prices & Follow Stores".tr,
                "Monitor price changes continuously and follow your favorite stores to never miss their latest updates and special offers.".tr),
            _buildPage('assets/lottie/aaaa.json', "Stay Notified".tr,
                "Enable notifications to get instant alerts whenever new deals are added. Never miss out on exciting offers again!".tr),
          ],
          onDone: () => Get.toNamed('/AccountTypeSelection'),
          onSkip: () => Get.toNamed('/AccountTypeSelection'),
          showSkipButton: true,
          skip: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Skip'.tr, style: const TextStyle(color: Colors.white)),
          ),
          next: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward, color: _gradientColors[_currentPage][0]),
          ),
          done: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text('Done'.tr, style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _gradientColors[_currentPage][0],
            )),
          ),
          curve: Curves.easeInOutCubicEmphasized,
          animationDuration: 600,
          globalBackgroundColor: Colors.transparent,
          dotsDecorator: DotsDecorator(
            activeColor: Colors.white,
            color: Colors.white38,
            activeSize: const Size(22, 10),
            size: const Size(10, 10),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPage(String lottiePath, String title, String body) {
    return PageViewModel(
      decoration: PageDecoration(
        imagePadding: const EdgeInsets.only(top: 50),
        bodyAlignment: Alignment.center,
        imageAlignment: Alignment.center,
        pageColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
          height: 1.5,
        ),
      ),
      title: title,
      body: body,
      image: FadeTransition(
        opacity: _animationController,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
          ),
          child: Lottie.asset(lottiePath, height: 350),
        ),
      ),
    );
  }
}