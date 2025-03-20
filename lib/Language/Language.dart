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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lang-member/langmem.png",
                  width: 191,
                  height: 196,
                ),
                const SizedBox(height: 100),
                Text(
                  "اختر اللغة",
                  style: GoogleFonts.castoro(fontSize: 30),
                ),
                const SizedBox(height: 15),
                Text(
                  "Choose The Language",
                  style: GoogleFonts.castoro(fontSize: 30),
                ),
                const SizedBox(height: 60),
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
                const SizedBox(height: 20),
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
