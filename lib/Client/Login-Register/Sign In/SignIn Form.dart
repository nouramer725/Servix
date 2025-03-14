import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import '../../../Components/AuthService_Google.dart';
import '../../../Components/Buttons.dart';
import '../../../Components/Remember me checkbox.dart';
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../Components/SocialMediaLoginButton.dart';
import '../../../Components/TextFormField_SignIn.dart';
import '../../../constents/constent.dart';
import '../../Home.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

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
            if (user.emailVerified) {
              // User is a Client → Allow access to ClientHome
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            } else {
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
                          color:  ApplicationColor, // Red background
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
                              "Email not verified. Please verify your account via the email sent to you."
                                  .tr(),
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
                  });
            }
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
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ResetPasswordDialog(),
                  );
                },
                child: Text(
                  "Forgot Password?".tr(),
                  style:  GoogleFonts.cantataOne(
                    fontSize: 18,
                    color: ApplicationColor,
                  ),
                ),
              ),
            ),
            RememberMeCheckbox(
              value: _rememberMe,
              onChanged: (value) => setState(() => _rememberMe = value!),
            ),
            const SizedBox(height: 50),
            GradientButton(
                onPressed: _isLoading ? null : _validateAndSubmit,
                text: "Sign In".tr()),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ".tr(),
                  style: GoogleFonts.charisSil(fontSize: 20),
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
                      color: ApplicationColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Social Media Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SocialMediaLoginButton(
                  imagePath: 'assets/images/social_media/google.png',
                  onTap: () async {
                    try {
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
                    } catch (e) {
                      print("Error signing in: $e");
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
