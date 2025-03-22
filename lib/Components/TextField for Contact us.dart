import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Theme/Theme_Provider.dart';

Widget customTextFieldContact({
  required TextEditingController controller,
  required String labelText,
  required TextInputType keyboardTypee,
  String? errorText,
  Function()? onVisibilityToggle, required ThemeProvider themeProvider,
}) {
  return Column(
    children: [
      TextFormField(
        controller: controller,
        keyboardType: keyboardTypee,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.castoro(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xE0E8E6E6), width: 1),
            borderRadius: BorderRadius.circular(10), // Increased rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xE0E8E6E6), width: 1),
            borderRadius: BorderRadius.circular(10), // Increased rounded corners
          ),
        ),
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 17),
    ],
  );
}
