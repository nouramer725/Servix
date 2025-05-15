import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget countryCodePhoneField({
  required TextEditingController controller,
  required String? errorText,
  required BuildContext context, // Added context param to use MediaQuery
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Using relative sizes instead of fixed values
  final containerWidth = screenWidth * 0.18; // ~70 px for small screens
  final containerPaddingVertical = screenHeight * 0.02; // ~16 px
  final containerPaddingHorizontal = screenWidth * 0.03; // ~12 px
  final fontSizeLabel = screenWidth * 0.045; // ~18 px
  final fontSizeText = screenWidth * 0.034; // ~16 px
  final errorFontSize = screenWidth * 0.035; // ~14 px
  final spacingWidth = screenWidth * 0.02; // ~8 px
  final spacingHeight = screenHeight * 0.022; // ~17 px

  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 70,
            padding: EdgeInsets.symmetric(
              horizontal: containerPaddingHorizontal,
              vertical: containerPaddingVertical,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Text(
                "+20".tr(),
                style: GoogleFonts.castoro(fontSize: fontSizeText),
              ),
            ),
          ),
          SizedBox(width: spacingWidth),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              cursorColor: Colors.grey[100],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: InputDecoration(
                labelText: "Phone Number".tr(),
                labelStyle: GoogleFonts.castoro(
                  fontSize: fontSizeLabel,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.31),
                ),
                prefixIcon: const Icon(Icons.phone, color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
      if (errorText != null)
        Padding(
          padding: EdgeInsets.only(
              top: spacingHeight * 0.3, left: spacingWidth * 0.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                errorText,
                style: GoogleFonts.castoro(
                    color: Colors.red, fontSize: errorFontSize),
              ),
            ],
          ),
        ),
      SizedBox(height: spacingHeight),
    ],
  );
}
