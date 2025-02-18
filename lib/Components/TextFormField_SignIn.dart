import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final IconData icon;
  final Function()? onTapSuffix;

  CustomTextFormField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    required this.icon,
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
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.31),
            ),
            prefixIcon: Icon(icon, color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.transparent,
            suffixIcon: onTapSuffix != null
                ? IconButton(
              icon: Icon(obscureText
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: onTapSuffix,
            )
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5),
            child: Row(
              children: [
                Text(
                  errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}