import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us".tr(),
          style: GoogleFonts.cantataOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black

          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/lang-member/langmem.png",
                width: 191,
                height: 196,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.castoro(
                      fontSize: 12,
                        color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black
                    ),
                    children: [
                      _buildNormalText("We are dedicated to providing ".tr()),
                      _buildBoldText(
                          "[ Home, Care, Woman ,Man ,Devices and Delivery Services ] "
                              .tr()),
                      _buildNormalText(
                          "with convenience and reliability.\nOur goal is to connect users with trusted service providers to ensure a seamless experience\n\n"
                              .tr()),
                      _buildBoldText("Why Choose Us?\n".tr()),
                      _buildNormalText(
                          "✔️ Reliable Services – Verified professionals you can trust. \n ✔️ Easy Booking – Quick and hassle-free scheduling.\n ✔️ Secure Payments – Safe and transparent transactions.\n ✔️ 24/7 Support – We’re here whenever you need help.\n\n\n"
                              .tr()),
                      _buildNormalText("Thank you for choosing ".tr()),
                      _buildBoldText("[SERVIX]! 🚀"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildBoldText(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
    );
  }

  TextSpan _buildNormalText(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.castoro(fontSize: 12),
    );
  }
}
