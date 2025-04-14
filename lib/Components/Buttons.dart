import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/constents/constent.dart';

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
                maxLines: 3,
              ),
            ),
          );
  }
}

class GradientButtonOffer extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double font;
  final bool isLoading; // Added loading state

  const GradientButtonOffer({
    required this.onPressed,
    required this.text,
    required this.font,
    this.isLoading = false, // Default is false
    super.key,
  });

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
      constraints: const BoxConstraints(
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
        onPressed:
        isLoading ? null : onPressed, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.charisSil(
            fontSize: font,
            color: Colors.white,
          ),
          maxLines: 3,
        ),
      ),
    );
  }
}

class WhiteButtonOffer extends StatelessWidget {
  final String text;
  final double font;
  final VoidCallback onPressed;

  const WhiteButtonOffer({
    super.key,
    required this.text,
    required this.font,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:const Color( 0xffAEAEAE),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text.tr(),
          style: GoogleFonts.charisSil(
            fontSize: font,
            color:const Color(0xff979292),
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
