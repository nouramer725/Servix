import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';

import '../Theme/Theme_Provider.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading; // Added loading state

  const GradientButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false, // Default is false
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            // Show the CircularProgressIndicator instead of the button
            child: CircularProgressIndicator(
              color: ApplicationColor,
              strokeWidth: 5,
            ),
          )
        : Container(
            constraints: BoxConstraints(
              minHeight: 0, // Allow shrinking if needed
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ApplicationColor2,
                  ApplicationColor,
                  ApplicationColor3,
                ],
                stops: [0.19, 0.46, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.37),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4), // Moves shadow 4 pixels downward
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed:
                  isLoading ? null : onPressed, // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.charisSil(
                  fontSize: 27,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
          );
  }
}

class GradientButtonOffer extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const GradientButtonOffer({
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ApplicationColor2,
            ApplicationColor,
            ApplicationColor3,
          ],
          stops: const [0.19, 0.46, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.37),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // Moves shadow 4 pixels downward
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.charisSil(
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}

class WhiteButtonOffer extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const WhiteButtonOffer({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xffAEAEAE),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text.tr(),
          style: GoogleFonts.charisSil(
            fontSize: 15,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Color(0xFF979292),
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
