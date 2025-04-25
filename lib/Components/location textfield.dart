import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormFieldLocation extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final Function()? onTapSuffix;

  const CustomTextFormFieldLocation({
    required this.label,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onTapSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            cursorColor: Colors.grey[100],
            initialValue: controller == null ? initialValue : null, // Ensure one is used
            obscureText: obscureText,
            readOnly: readOnly,
            style: GoogleFonts.castoro(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              labelText: label,
              labelStyle: GoogleFonts.castoro(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.22),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.transparent,
            )
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorText!,
              style:  GoogleFonts.castoro(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}