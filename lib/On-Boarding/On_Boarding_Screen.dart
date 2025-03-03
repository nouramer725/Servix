import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Language/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      title: 'Explore Our Services',
      body:
      'Our app offers a seamless experience, connecting you with skilled technicians for home repairs and maintenance.',
    ),
    Onboarding(
      image: 'assets/images/on-boarding/tech.png',
      title: 'Find Skilled Technicians',
      body:
      'Need a repair, installation, or maintenance service? Our platform connects you with certified and experienced technicians.',
    ),
    Onboarding(
      image: 'assets/images/on-boarding/robot.png',
      title: 'Smart AI',
      body:
      'Our AI assistant helps with instant troubleshooting, smart recommendations, and automated support for various tasks.',
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
                'Skip',
                style: GoogleFonts.charisSil(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF821717), // Deep red
              Color(0xFF5D1010), // Lighter red
              Color(0xFF1C0505), // Even lighter red
            ],
            stops: [0.09, 0.45, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(25.0),
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
                itemBuilder: (context, index) =>
                    buildOnBoarding(boarding[index]),
              ),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: swipeController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.white,
                    spacing: 3,
                    dotWidth: 10,
                    expansionFactor: 4,
                    activeDotColor: Colors.white,
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
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Color(0xFF821717)),
                  elevation: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoarding(Onboarding model) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Text(
                model.title,
                style: GoogleFonts.charisSil(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                model.image,
                width: 367,
                height: 395,
              ),
            ),
            Text(
              model.body,
              style: GoogleFonts.baskervville(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
