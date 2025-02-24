import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Member/MemberShip.dart';

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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.37),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Set locale to Arabic
                      context.setLocale(const Locale('ar'));
                      // Navigate to MemberShip screen after changing locale
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MemberShip()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "العربية",
                        style: GoogleFonts.charisSil(fontSize: 30, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: () {
                    // Set locale to English
                    context.setLocale(const Locale('en'));
                    // Navigate to MemberShip screen after changing locale
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MemberShip()),
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
