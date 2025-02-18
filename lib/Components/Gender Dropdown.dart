import 'package:flutter/material.dart';

Widget genderDropdown({
  required String? selectedValue,
  required Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    hint: const Text("Gender"),
    items: ["Male", "Female"].map((String category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category),
      );
    }).toList(),
    onChanged: onChanged,
  );
}
