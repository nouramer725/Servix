import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget genderDropdown({
  required String? selectedValue,
  required Function(String?) onChanged,
  String? errorText,
}) {
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
        hint: Text("Gender".tr()),
        dropdownColor: Colors.white, // Dropdown background color
        items: ["Male".tr(), "Female".tr()].map((String category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: onChanged,
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
    ],
  );
}
