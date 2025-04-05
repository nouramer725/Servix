import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart';
import '../constents/constent.dart';

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword(String email) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email".tr(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Password reset link sent! Check your email.".tr(),
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}".tr(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? const Color(0xFF333739)
          : Colors.white,
      title: Text(
        "Reset Password".tr(),
        style: GoogleFonts.charisSil(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: themeProvider.themeMode == ThemeMode.dark
              ? Colors.white
              : ApplicationColor,
        ),
      ),
      content: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "Enter your email".tr(),
          focusColor: ApplicationColor,
          labelStyle: GoogleFonts.charisSil(
              color: Color(0xffAEAEAE)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffAEAEAE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffAEAEAE)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffAEAEAE)),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel".tr(),
            style: GoogleFonts.charisSil(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : () => _resetPassword(_emailController.text.trim()),
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
            "Send Reset Email".tr(),
            style: GoogleFonts.charisSil(
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : ApplicationColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
