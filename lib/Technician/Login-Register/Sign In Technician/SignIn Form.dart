import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/Technician/Login-Register/SignUP/Sign_Up_Tech.dart';
import '../../../../Components/Buttons.dart';
import '../../../../Components/TextFormField_SignIn.dart';
import '../../../Components/AuthService_Google.dart';
import '../../../Components/Remember me checkbox.dart';
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../Components/SocialMediaLoginButton.dart';
import '../../Home/HomeTechnician.dart';
import '../../../constents/constent.dart';

class SignInFormTech extends StatefulWidget {
  @override
  _SignInFormTechState createState() => _SignInFormTechState();
}

class _SignInFormTechState extends State<SignInFormTech> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? emailError;
  String? passwordError;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _validateAndSubmit() async {
    setState(() {
      emailError = null;
      passwordError = null;
      _isLoading = true;
    });

    bool isValid = true;

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Please enter your email".tr();
        _isLoading = false;
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Please enter your password".tr();
        _isLoading = false;
      });
      isValid = false;
    }

    if (isValid) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
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
                      color: ApplicationColor, // Red background
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
                        const SizedBox(height: 16),
                        Text(
                          "BUT WITH DIFFERENT EMAIL ADDRESS ".tr(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeTechnicianLayout()),
          );
        }
      } on FirebaseAuthException catch(e) {
        print(e);
        String message = '';
        if (e.code == 'invalid-email') {
          message = 'No user found for that email.';
        } else if (e.code == 'invalid-credential') {
          message = 'Wrong password or email address provided for that user.';
        }
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
      catch(e){
        print(e);
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: emailError,
              icon: Icons.email,
            ),
            const SizedBox(height: 17),
            CustomTextFormField(
              label: "Password".tr(),
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              errorText: passwordError,
              icon: Icons.lock,
              obscureText: _obscureText,
              onTapSuffix: () => setState(() => _obscureText = !_obscureText),
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
                  style: GoogleFonts.cantataOne(
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
              text: "Sign In".tr(),
            ),
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
                      MaterialPageRoute(
                          builder: (context) => SignUpTechnician()),
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
                            MaterialPageRoute(
                                builder: (context) => HomeTechnician()),
                          );
                        }
                      } else {
                        print("User sign-in failed".tr());
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
