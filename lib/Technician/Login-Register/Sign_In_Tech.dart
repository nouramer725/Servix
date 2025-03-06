import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Technician/Home/HomeTechnician.dart';
import '../../Components/AuthService_Google.dart';
import '../../Components/Buttons.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormField_SignIn.dart';
import 'Sign_Up_Tech.dart';

class SignInTechnician extends StatefulWidget {
  @override
  _SignInTechnicianState createState() => _SignInTechnicianState();
}

class _SignInTechnicianState extends State<SignInTechnician> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndSubmit() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    bool isValid = true;

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "Please enter your email".tr();
        _isLoading = false;
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password".tr();
        _isLoading = false;
      });
      isValid = false;
    }

    if (isValid) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          // Check if this account is registered as a technician.
          DocumentSnapshot techDoc = await FirebaseFirestore.instance
              .collection('technician')
              .doc(user.uid)
              .get();

          if (!techDoc.exists) {
            // This account is not in the technician collection.
            await FirebaseAuth.instance.signOut();
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF821717), // Red background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "This account is for clients only. Please create a technician account."
                              .tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "BUT WITH DIFFERENT EMAIL ADDRESS "
                              .tr(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK".tr(),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            return; // Exit without proceeding further.
          }

          // Now, check if the email is verified.
          if (user.emailVerified) {
            // Retrieve extra sign-up data passed via route arguments.
            final Map<String, dynamic>? signUpData =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

            // If data exists, save/merge it to Firestore.
            if (signUpData != null) {
              await FirebaseFirestore.instance
                  .collection('technician')
                  .doc(user.uid)
                  .set(signUpData, SetOptions(merge: true));
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeTechnician()),
            );
          } else {
            // Email not verified: sign out and show alert dialog.
            await FirebaseAuth.instance.signOut();
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF821717), // Red background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Email not verified. Please verify your account via the email sent to you.".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK".tr(),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'wrong-password') {
          errorMessage = "The password is incorrect. Please try again.".tr();
        } else if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email address.".tr();
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is invalid.".tr();
        } else {
          errorMessage = "An unknown error occurred. Please try again.".tr();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      context.locale.languageCode == 'ar'
                          ? "assets/images/sign/inArabic.png"
                          : "assets/images/sign/in.png",
                      alignment: Alignment.topLeft,
                      width: 502,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: "Email".tr(),
                        controller: _emailController,
                        icon: Icons.email,
                        errorText: _emailError,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 17),
                      CustomTextFormField(
                        label: "Password".tr(),
                        controller: _passwordController,
                        icon: Icons.lock,
                        obscureText: _obscureText,
                        errorText: _passwordError,
                        onTapSuffix: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF9A2B2B),
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          Text(
                            "Remember Me".tr(),
                            style: GoogleFonts.charisSil(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      GradientButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        text: "Sign In".tr(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Don't have an account? ".tr(),
                              style: GoogleFonts.charisSil(fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpTechnician()),
                              );
                            },
                            child: Text(
                              " SignUp".tr(),
                              style: GoogleFonts.charisSil(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF9A2B2B),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          SocialMediaLoginButton(
                            imagePath: 'assets/images/social_media/google.png',
                            onTap: () async {
                              User? user = await _authService.signInWithGoogle();
                              if (user != null) {
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeTechnician()),
                                  );
                                }
                              } else {
                                print("User sign-in failed".tr());
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    ],
      ),
    );
  }
}
