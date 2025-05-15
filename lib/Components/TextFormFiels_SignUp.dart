import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart'; // Make sure to import provider

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  Icon? prefixIcon,
  required TextInputType keyboardTypee,
  bool obscureText = false,
  String? errorText,
  Function()? onVisibilityToggle,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Column(
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardTypee,
            readOnly: readOnly,
            inputFormatters: inputFormatters,
            validator: validator,
            cursorColor: Colors.grey[100],
            style: GoogleFonts.castoro(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: GoogleFonts.castoro(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                letterSpacing: 0.2,
              ),
              filled: false,
              fillColor: Colors.grey[100],
              prefixIcon: prefixIcon,
              prefixIconColor: Colors.black,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              suffixIcon: onVisibilityToggle != null
                  ? IconButton(
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: onVisibilityToggle,
                    )
                  : null,
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    errorText,
                    style: GoogleFonts.castoro(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 17),
        ],
      );
    },
  );
}
