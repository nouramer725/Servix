import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Member/MemberShip.dart';
import '../Components/White Buttons.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final imageWidth = screenWidth * 0.5;
    final imageHeight = screenHeight * 0.25;

    final titleFontSize = screenWidth * 0.07;
    final spacingLarge = screenHeight * 0.06;
    final spacingMedium = screenHeight * 0.02;
    final spacingSmall = screenHeight * 0.01;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // 5% padding all around
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lang-member/langmem.png",
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: spacingLarge),
                Text(
                  "اختر اللغة",
                  style: GoogleFonts.castoro(fontSize: titleFontSize),
                ),
                SizedBox(height: spacingSmall),
                Text(
                  "Choose The Language",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.castoro(fontSize: titleFontSize),
                ),
                SizedBox(height: spacingLarge),
                WhiteButton(
                  text: "العربية",
                  onPressed: () {
                    context.setLocale(const Locale('ar'));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberShip()),
                      (route) => false,
                    );
                  },
                ),
                SizedBox(height: spacingMedium),
                GradientButton(
                  onPressed: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberShip()),
                      (route) => false,
                    );
                  },
                  text: "English",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
