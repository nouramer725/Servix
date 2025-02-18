import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required Icon prefixIcon,
  required TextInputType keyboardTypee,
  bool obscureText = false,
  String? errorText,
  Function()? onVisibilityToggle,
}) {
  return Column(
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardTypee,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.31),
          ),
          prefixIcon: prefixIcon,
          enabledBorder: const OutlineInputBorder(
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
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      const SizedBox(height: 17),
    ],
  );
}
