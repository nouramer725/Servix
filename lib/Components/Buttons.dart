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
