import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Technician/Login-Register/Personal%20Info/Personal%20Info%20tech.dart';

import '../../../constents/constent.dart';

class VerificationTech extends StatefulWidget {
  final String email;
  final String password;

  const VerificationTech(
      {super.key, required this.email, required this.password});

  @override
  State<VerificationTech> createState() => _VerificationTechState();
}

class _VerificationTechState extends State<VerificationTech> {
  bool isVerified = false;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    _signInOnceAndStartCheck();
  }

  void _signInOnceAndStartCheck() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      _startVerificationCheck();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Sign in failed".tr(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _startVerificationCheck() async {
    if (isChecking) return;
    isChecking = true;

    while (!isVerified) {
      await Future.delayed(const Duration(seconds: 5));

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null && refreshedUser.emailVerified) {
          setState(() {
            isVerified = true;
          });

          Fluttertoast.showToast(
            msg: "Email verified successfully".tr(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: ApplicationColorWithOpacity,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalInformation(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "Error checking verification".tr(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Lottie.asset(
                'assets/Application/email-verification.json',
                width: 500,
              ),
              Text(
                "Verify Your Email Address".tr(),
                style: GoogleFonts.charisSil(
                  fontSize: 25,
                  color: ApplicationColor3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "You have entered {{email}} as your email address. Please check your inbox for a verification link."
                    .tr(namedArgs: {'email': widget.email}),
                style: GoogleFonts.charisSil(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              GradientButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && !user.emailVerified) {
                    try {
                      await user.sendEmailVerification();
                      Fluttertoast.showToast(
                        msg: "Verification email sent".tr(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        backgroundColor: ApplicationColorWithOpacity,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } on FirebaseAuthException catch (e) {
                      Fluttertoast.showToast(
                        msg: "Verification email sent".tr(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        backgroundColor: ApplicationColorWithOpacity,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // Fluttertoast.showToast(
                      //   msg: e.message ?? "Too many requests. Try later.".tr(),
                      //   backgroundColor: Colors.red,
                      //   textColor: Colors.white,
                      // );
                    }
                  }
                },
                text: "Resend Verification Email".tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
