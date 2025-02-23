import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormField_SignIn.dart';
import '../Home.dart';
import 'AuthService_Google.dart';
import 'Sign_Up.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
        _emailError = "Please enter your email";
        _isLoading = false;
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password";
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
          // Check if email is verified
          if (user.emailVerified) {
            // Retrieve extra sign up data passed via route arguments.
            final Map<String, dynamic>? signUpData =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

            // If data exists, save/merge it to Firestore.
            if (signUpData != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set(signUpData, SetOptions(merge: true));
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
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
                        const Text(
                          "Email not verified. Please verify your account via the email sent to you.",
                          style: TextStyle(
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
                          child: const Text(
                            "OK",
                            style: TextStyle(
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
          errorMessage = "The password is incorrect. Please try again.";
        } else if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email address.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is invalid.";
        } else {
          errorMessage = "The password is incorrect. Please try again.";
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Image.asset(
                  "assets/images/sign/in.png",
                  alignment: Alignment.topLeft,
                  width: 502,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: "Email",
                      controller: _emailController,
                      icon: Icons.email,
                      errorText: _emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 17),
                    CustomTextFormField(
                      label: "Password",
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
                          "Remember Me",
                          style: GoogleFonts.charisSil(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    GradientButton(
                      onPressed: _isLoading ? null : _validateAndSubmit,
                      text: "Sign In",
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Don't have an account? ",
                            style: GoogleFonts.charisSil(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Text(
                            "SignUp",
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
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              }
                            } else {
                              print("User sign-in failed");
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
    );
  }
}
