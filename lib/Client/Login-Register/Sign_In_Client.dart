import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormField_SignIn.dart';
import '../Home.dart'; // Client Home Screen
import '../../Components/AuthService_Google.dart';
import 'Sign_Up_Client.dart';

class SignInClient extends StatefulWidget {
  @override
  _SignInClientState createState() => _SignInClientState();
}

class _SignInClientState extends State<SignInClient> {
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
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          // Check if user is a technician
          DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
              .collection('technician')
              .doc(user.uid)
              .get();

          if (technicianDoc.exists) {
            // User is a Technician → Allow access to both ClientHome & TechnicianHome
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else {
            // User is a Client → Can only access ClientHome
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'wrong-password'.tr()) {
          errorMessage = "The password is incorrect. Please try again.".tr();
        } else if (e.code == 'user-not-found'.tr()) {
          errorMessage = "No user found for that email address.".tr();
        } else if (e.code == 'invalid-email'.tr()) {
          errorMessage = "The email address is invalid.".tr();
        } else {
          errorMessage = "An unexpected error occurred. Please try again.".tr();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20), // Add some spacing for better layout
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.topLeft, // Ensures image stays at top-left
                      child: Image.asset(
                        context.locale.languageCode == 'ar'
                            ? "assets/images/sign/inArabic.png"
                            : "assets/images/sign/in.png",
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
                                  MaterialPageRoute(builder: (context) => SignUpClient()),
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
