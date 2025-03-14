import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email".tr())),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset link sent! Check your email.".tr()),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}".tr()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Reset Password".tr(),
        style: GoogleFonts.charisSil(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ApplicationColor,
        ),
      ),
      content: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "Enter your email".tr(),
          focusColor: ApplicationColor,
          border: const OutlineInputBorder(),
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
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: ApplicationColor,
            ),
          ),
        ),
      ],
    );
  }
}
