import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Login-Register/Sign%20In/Sign_In_Client.dart';
import 'package:servix/Technician/Login-Register/Sign%20In%20Technician/Sign_In_Tech.dart';
import '../Components/Buttons.dart';
import '../Components/White Buttons.dart';

class MemberShip extends StatelessWidget {
  const MemberShip({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Dynamic sizes based on screen dimensions
    final imageWidth = screenWidth * 0.5;
    final imageHeight = screenHeight * 0.25;

    final titleFontSize = screenWidth * 0.07;
    final spacingLarge = screenHeight * 0.06;
    final spacingMedium = screenHeight * 0.02;
    final paddingAll = screenWidth * 0.05;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(paddingAll),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lang-member/langmem.png",
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: spacingLarge),
                Text(
                  tr("Select MemberShip"),
                  style: GoogleFonts.castoro(
                    fontSize: titleFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacingLarge),
                WhiteButton(
                  text: "Technician",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInTechnician()),
                    );
                  },
                ),
                SizedBox(height: spacingMedium),
                GradientButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInClient()),
                    );
                  },
                  text: tr("Client"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
