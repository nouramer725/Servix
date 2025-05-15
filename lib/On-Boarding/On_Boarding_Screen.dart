import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Language/Language.dart';
import '../constents/constent.dart';

class Onboarding {
  final String image;
  final String title;
  final String body;

  Onboarding({required this.image, required this.title, required this.body});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Onboarding> boarding = [
    Onboarding(
      image: 'assets/images/on-boarding/explore.png',
      title: 'Explore Our Services'.tr(),
      body:
          'Our app offers a seamless experience, connecting you with skilled technicians for home repairs and maintenance.'
              .tr(),
    ),
    Onboarding(
      image: 'assets/images/on-boarding/tech.png',
      title: 'Find Skilled Technicians'.tr(),
      body:
          'Need a repair, installation, or maintenance service? Our platform connects you with certified and experienced technicians.'
              .tr(),
    ),
    Onboarding(
      image: 'assets/images/on-boarding/robot.png',
      title: 'Community Forum'.tr(),
      body:
          'Join our vibrant community to connect, share ideas, and learn from fellow language learners. Together, we can achieve more!'
              .tr(),
    ),
    Onboarding(
      image: 'assets/images/on-boarding/robot.png',
      title: 'Smart AI'.tr(),
      body:
          'Our AI assistant helps with instant troubleshooting, smart recommendations, and automated support for various tasks.'
              .tr(),
    ),
  ];

  var swipeController = PageController();
  bool isLast = false;

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Language()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsiveness
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Responsive padding based on screen width
    final paddingSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: completeOnboarding, // Skip onboarding
              child: Text(
                'Skip'.tr(),
                style: GoogleFonts.charisSil(
                  fontSize: screenWidth * 0.07, // responsive font size
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ApplicationColor, // Deep red
              ApplicationColor4, // Lighter red
              ApplicationColor3, // Darker red
            ],
            stops: const [0.09, 0.45, 1.0],
          ),
        ),
        padding: EdgeInsets.all(paddingSize),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: swipeController,
                onPageChanged: (index) {
                  setState(() {
                    isLast = index == boarding.length - 1;
                  });
                },
                itemCount: boarding.length,
                itemBuilder: (context, index) => buildOnBoarding(
                  boarding[index],
                  screenWidth,
                  screenHeight,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: swipeController,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.white.withOpacity(0.5),
                    spacing: 6,
                    dotWidth: screenWidth * 0.025,
                    expansionFactor: 4,
                    activeDotColor: Colors.white,
                    dotHeight: screenWidth * 0.025,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if (isLast) {
                      completeOnboarding();
                    } else {
                      swipeController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios,
                      color: ApplicationColor,
                      size: screenWidth * 0.06 // responsive icon size
                      ),
                  elevation: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoarding(
      Onboarding model, double screenWidth, double screenHeight) {
    // Responsive sizes
    double titleFontSize = screenWidth * 0.08; // ~30 at 375 width
    double bodyFontSize = screenWidth * 0.045; // ~17 at 375 width
    double imageWidth = screenWidth * 0.85;
    double imageHeight = screenHeight * 0.45;
    double topSpacing = screenHeight * 0.12;
    double bodyHorizontalPadding = screenWidth * 0.05;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: topSpacing),
            Text(
              model.title,
              style: GoogleFonts.charisSil(
                fontSize: titleFontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
            Image.asset(
              model.image,
              width: imageWidth,
              height: imageHeight,
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: bodyHorizontalPadding),
              child: Text(
                model.body,
                style: GoogleFonts.baskervville(
                  fontSize: bodyFontSize,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
