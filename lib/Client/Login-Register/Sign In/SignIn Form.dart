import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Verification%20Email.dart';
import '../../../Components/AuthService_Google.dart';
import '../../../Components/Buttons.dart';
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../Components/TextFormField_SignIn.dart';
import '../../../constents/constent.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
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

    if (!isValid) return;

    _formKey.currentState!.save();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
            .collection('technician')
            .doc(user.uid)
            .get();
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Case 1: Both technician and user documents exist
        if (technicianDoc.exists && userDoc.exists) {
          _navigateToClientHome();
        }

        // Case 2: Only user document exists
        else if (!technicianDoc.exists && userDoc.exists) {
          if (user.emailVerified) {
            _navigateToClientHome();
          } else {
            _navigateToVerification();
          }
        }

        if (technicianDoc.exists && !userDoc.exists) {
          final role = technicianDoc.get('role');
          if (role == 'Client') {
            _navigateToClientHome();
          } else if (role == 'Technician') {
            // Update the role to 'Client'
            await technicianDoc.reference.update({'role': 'Client'});
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'first_name': technicianDoc.get('first_name'),
              'last_name': technicianDoc.get('last_name'),
              'email': technicianDoc.get('email'),
              'phone': technicianDoc.get('phone'),
              'gender': technicianDoc.get('gender'),
              'role': 'Client', // Switch role to 'Client'
            });
            _navigateToClientHome();
          } else {
            // _showTechnicianOnlyDialog();
          }
        } else {
          // Fluttertoast.showToast(
          //   msg: "This User Does not have an account in Servix application",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.SNACKBAR,
          //   backgroundColor: ApplicationColorWithOpacity,
          //   textColor: Colors.white,
          //   fontSize: 15.0,
          // );
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = '';
      if (e.code ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'No user found with this Data.';
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      } else {
        message = e.message ?? 'An error occurred';
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "No user found for that email.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToClientHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeClientLayout()),
    );
  }

  void _navigateToVerification() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Verification(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      ),
    );
  }

  // void _showTechnicianOnlyDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: ApplicationColor,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(Icons.close, color: Colors.white, size: 40),
  //               const SizedBox(height: 8),
  //               Text(
  //                 "This account does not have access to Servix".tr(),
  //                 style: const TextStyle(color: Colors.white, fontSize: 16),
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: 16),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.white,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   "OK".tr(),
  //                   style: const TextStyle(
  //                     color: Colors.black87,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
              alignment: Alignment.centerLeft,
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
            const SizedBox(height: 30),
            // Social Media Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFD6D6D6))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or signin by".tr(),
                        style: GoogleFonts.inter(
                            color: const Color(0xFF898989), fontSize: 12),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFD6D6D6))),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      User? user = await _authService.signInWithGoogle();
                      if (user != null) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeClientLayout()),
                          );
                        }
                      } else {
                        print("User sign-in failed");
                      }
                    } catch (e) {
                      print("Error signing in: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFAEAEAE)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/social_media/google.png',
                        height: 28,
                        width: 29,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Sign in with Google".tr(),
                        style: GoogleFonts.inter(
                            fontSize: 16, color: const Color(0xFF828282)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
