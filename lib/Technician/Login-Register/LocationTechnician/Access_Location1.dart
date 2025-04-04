import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Buttons.dart';
import '../../../Settings/Privacy Policy.dart';
import 'Google Maps.dart';

class LocationRequestScreenTech extends StatelessWidget {
  final String phoneNumber;

  const LocationRequestScreenTech ({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/location/location.png",
                  width: 391,
                  height: 346,
                ),
                SizedBox(height: 40),
                Text(
                  "By allowing access , you consent to share your personal info with Google maps as stated in the".tr(),
                  style: GoogleFonts.charisSil(
                    fontSize: 16,
                    color: Color(0xFF7D7C7C),
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ));
                  },
                  child: Text(
                    "Privacy Policy".tr(),
                    style: GoogleFonts.charisSil(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Color(0xFF6D6C6C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GradientButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMapScreenTech(
                          phoneNumber: phoneNumber,
                        ),
                      ),
                          (route) => false, // Removes all previous routes
                    );
                  },
                  text: "Allow Access".tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
