import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';

class LocationRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/location/img.png",
                  width: 391,
                  height: 346,
                ),
                SizedBox(height: 60),
                Text(
                  "By allowing access , you consent to share your personal info with Google maps as stated in the",
                  style: GoogleFonts.charisSil(
                      fontSize: 16,
                      color: Color(0xFF7D7C7C)),
                ),
                Text(
                  "Privacy Policy",
                  style: GoogleFonts.charisSil(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Color(0xFF6D6C6C)),
                ),
                SizedBox(
                  height: 20,
                ),
                GradientButton(
                  onPressed: () {},
                  text: "Allow Access",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
