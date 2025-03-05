import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget roleDropdown({required String selectedValue}) {
  return DropdownButtonFormField<String>(
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
    items: [
      DropdownMenuItem(
        value: "Client",
        child: Text(
          "Client".tr(),
        ),
      ),
    ],
    onChanged: null, // This disables selection
  );
}
