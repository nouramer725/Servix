import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/constents/constent.dart';

class OfferButtonInOrderCard extends StatelessWidget {
  final VoidCallback? onPressed;

  const OfferButtonInOrderCard({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: context.locale.languageCode == 'ar'
          ? Alignment.bottomLeft
          : Alignment.bottomRight,
      child: SizedBox(
        width: 100,
        height: 40,
        child: Container(
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
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero, // Ensures button fits inside Container
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Offers',
              style: GoogleFonts.charisSil(
                fontSize: 18, // Adjusted for button size
                color: Colors.white,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
