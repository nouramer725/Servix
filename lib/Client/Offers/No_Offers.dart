import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';

class NoOffersScreen extends StatelessWidget {
  const NoOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/offers/noOffers.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
               Text(
                'No Offers Yet'.tr(),
                 style: GoogleFonts.castoro(
                   fontSize: 35,
                   fontWeight: FontWeight.w900,
                   color: themeProvider.themeMode == ThemeMode.dark
                       ? Colors.white
                       : Colors.black,
                 ),
              ),
              const SizedBox(height: 8),
               Text(
                "Your Offers will appear here once\nif you’ve received them.".tr(),
                textAlign: TextAlign.center,
                 style: GoogleFonts.castoro(
                   fontSize: 18,
                   fontWeight: FontWeight.w400,
                   color: themeProvider.themeMode == ThemeMode.dark
                       ? Colors.white
                       : Colors.black,
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
