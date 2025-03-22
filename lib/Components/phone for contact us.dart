import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Theme/Theme_Provider.dart';

Widget countryCodePhoneFieldContactUs({
  required TextEditingController controller,
  required String? errorText, required ThemeProvider themeProvider,
}) {
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xE0E8E6E6)),
              borderRadius: BorderRadius.circular(10),

            ),
            child:  Center(
              child: Text(
                "+20".tr(),
                style: TextStyle(fontSize: 16, color: themeProvider.themeMode == ThemeMode.dark ? Colors.grey.shade400 : Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number".tr(),
                labelStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Icon(Icons.local_phone_sharp, color: themeProvider.themeMode == ThemeMode.dark ? Colors.grey.shade400 : Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xE0E8E6E6), width: 1),
                  borderRadius: BorderRadius.circular(10), // Increased rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xE0E8E6E6), width: 1),
                  borderRadius: BorderRadius.circular(10), // Increased rounded corners
                ),
              ),
            ),
          ),
        ],
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
