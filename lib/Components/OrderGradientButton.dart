import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constents/constent.dart';

class OrderGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const OrderGradientButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: ApplicationColor,
              strokeWidth: 5,
            ),
          )
        : Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 5), // Spacing between buttons
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
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.charisSil(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
