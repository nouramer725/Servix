import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Components/reset_password_white.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/Technician/Login-Register/SignUP/Sign_Up_Tech.dart';
import '../../../../Components/Buttons.dart';
import '../../../../Components/TextFormField_SignIn.dart';
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../constents/constent.dart';

class SignInFormTech extends StatefulWidget {
  @override
  _SignInFormTechState createState() => _SignInFormTechState();
}

class _SignInFormTechState extends State<SignInFormTech> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
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

    // Check if the device is connected to the internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "No internet connection. Please try again later.".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return;
    }

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

        if (techDoc.exists) {
          String roleTech = techDoc['role'] ?? '';

          if (roleTech == 'Technician') {
            // Set isActive to true for the technician
            await techDoc.reference.update({'isActive': true}); // Toggle isActive to true

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeTechnicianLayout()),
            );
          } else if (roleTech == 'Client') {
            // Update role to Technician and set isActive to true
            await techDoc.reference.update({'role': 'Technician', 'isActive': true});

            // Navigate to technician home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeTechnicianLayout()),
            );
          } else {
            Fluttertoast.showToast(
              msg: "You do not have Technician role.".tr(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: ApplicationColorWithOpacity,
              textColor: Colors.white,
              fontSize: 16,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "This account only for clients".tr(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ApplicationColorWithOpacity,
            textColor: Colors.white,
            fontSize: 16,
          );
        }
      } else {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
          msg: "User Data does not exist.".tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = '';
      if (e.code == 'user-not-found') {
        message = "No user found for that email.".tr();
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.".tr();
      } else {
        message = "This email address does not exist".tr();
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again later.".tr(),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
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
                    builder: (context) => ResetPasswordDialogWhite(),
                  );
                },
                child: Text(
                  "Forgot Password?".tr(),
                  style: GoogleFonts.cantataOne(
                    fontSize: 20,
                    color: ApplicationColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            GradientButton(
              onPressed: _isLoading ? null : _validateAndSubmit,
              text: "Sign In".tr(),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ".tr(),
                    style: GoogleFonts.charisSil(fontSize: 20),
                  ),
                  const SizedBox(width: 5), // Space between the two texts
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
            ),
          ],
        ),
      ),
    );
  }
}
