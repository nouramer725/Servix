import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constents/constent.dart';

Widget customDOBField({
  required TextEditingController controller,
  required String labelText,
  String? errorText,
  required VoidCallback onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.31),
          ),
          prefixIcon:  Icon(Icons.calendar_today_outlined, color: ApplicationColor),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
          ),
        ),
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      const SizedBox(height: 17),
    ],
  );
}
