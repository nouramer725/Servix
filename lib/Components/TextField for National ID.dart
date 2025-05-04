import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constents/constent.dart';

Widget customTextFieldNational({
  required TextEditingController controller,
  required String labelText,
  bool showError = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        cursorColor: Colors.grey[100],
        keyboardType: TextInputType.number,
        maxLength: 14,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allows only numbers
          LengthLimitingTextInputFormatter(14), // Restricts to 14 digits
        ],
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.castoro(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.31),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          errorText:
              showError ? 'National ID must be exactly 14 digits'.tr() : null,
          counterText: "", // Hides character counter
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
