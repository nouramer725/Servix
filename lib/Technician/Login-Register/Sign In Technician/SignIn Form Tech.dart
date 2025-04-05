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
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../constents/constent.dart';

class SignInFormTech extends StatefulWidget {
  @override
  _SignInFormTechState createState() => _SignInFormTechState();
}

class _SignInFormTechState extends State<SignInFormTech> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  // bool _rememberMe = false;
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

    if (!isValid) return;

    _formKey.currentState!.save();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Ensure this is the correct collection
            .doc(user.uid)
            .get();

        DocumentSnapshot techDoc = await FirebaseFirestore.instance
            .collection('technician') // Ensure this is the correct collection
            .doc(user.uid)
            .get();

        if (userDoc.exists && techDoc.exists) {
          String role = userDoc['role'] ?? '';
          String roleTech = techDoc['role'] ?? '';

          if (role == 'Client' && roleTech == 'Client') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeTechnicianLayout()),
            );
            // If user is a technician, navigate to home layout
            DocumentReference technicianRef = FirebaseFirestore.instance
                .collection('technician')
                .doc(user.uid);
            await technicianRef.update({
              'role': 'Technician',
            });
            DocumentReference userRef =
                FirebaseFirestore.instance.collection('users').doc(user.uid);
            await userRef.delete();
          }
        } else if (userDoc.exists == false && techDoc.exists) {
          String roleTech = techDoc['role'] ?? '';
          if (roleTech == 'Technician') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeTechnicianLayout()),
            );
          }
        } else if (userDoc.exists && techDoc.exists == false) {
          String role = userDoc['role'] ?? '';
          if (role == 'Technician') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeTechnicianLayout()),
            );
          }
        } else {
          // If user is a client, sign them out and show an alert
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
                        style: GoogleFonts.castoro(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "BUT WITH A DIFFERENT EMAIL ADDRESS".tr(),
                        style: GoogleFonts.castoro(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                          style: GoogleFonts.castoro(
                            color: Colors.black,
                            fontSize: 18,
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
      } else {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
          msg: "User Data does not exist.".tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

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
            // RememberMeCheckbox(
            //   value: _rememberMe,
            //   onChanged: (value) => setState(() => _rememberMe = value!),
            // ),
            const SizedBox(height: 100),
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
                                builder: (context) =>
                                    const HomeTechnicianLayout()),
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
