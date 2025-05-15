import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget genderDropdown({
  required String? selectedValue,
  required Function(String?) onChanged,
  String? errorText,
  required BuildContext context, // Added context to use MediaQuery
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final fontSize = screenWidth * 0.04; // ~16 for standard phones
  final errorFontSize = screenWidth * 0.035; // ~14
  final paddingTop = screenHeight * 0.006; // ~5
  final paddingLeft = screenWidth * 0.013; // ~5

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
          ),
        ),
        hint: Text(
          "Gender".tr(),
          style: GoogleFonts.castoro(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        dropdownColor: Colors.white,
        items: ["Male".tr(), "Female".tr()].map((String category) {
          return DropdownMenuItem(
            value: category,
            child: Text(
              category,
              style: GoogleFonts.castoro(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
      if (errorText != null)
        Padding(
          padding: EdgeInsets.only(top: paddingTop, left: paddingLeft),
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
    ],
  );
}
