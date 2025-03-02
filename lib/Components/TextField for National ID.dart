import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allows only numbers
          LengthLimitingTextInputFormatter(14), // Restricts to 14 digits
        ],
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default border
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF821717), width: 0.5), // Highlighted when focused
            borderRadius: BorderRadius.circular(5),
          ),
          errorText: showError ? 'National ID must be exactly 14 digits' : null,
          counterText: "", // Hides character counter
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
