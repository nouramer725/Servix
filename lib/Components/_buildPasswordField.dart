import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.grey[100],
      style: GoogleFonts.castoro(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: themeProvider.themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.black,
        letterSpacing: 0.2,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.castoro(
          color: const Color(0xffAEAEAE),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xffAEAEAE),
          ),
          onPressed: _toggleVisibility,
        ),
        filled: false,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffAEAEAE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffAEAEAE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffAEAEAE)),
        ),
      ),
    );
  }
}
