import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:servix/Client/Login-Register/LocationClient/Access_Location1.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Verification%20Email.dart';
import '../../../Components/Buttons.dart';
import '../../../Components/ShowResetPasswordDiaglog.dart';
import '../../../Components/TextFormField_SignIn.dart';
import '../../../constents/constent.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  String? _emailError;
  String? _passwordError;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        if (technicianDoc.exists && userDoc.exists) {
          _navigateToClientHome();
        } else if (!technicianDoc.exists && userDoc.exists) {
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
              'role': 'Client',
            });
            _navigateToClientHome();
          }
        } else {
          Fluttertoast.showToast(
            msg: "This user does not have an account in Servix application",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: ApplicationColorWithOpacity,
            textColor: Colors.white,
            fontSize: 15.0,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = '';
      if (e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else {
        message = e.message ?? 'An error occurred';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } on SocketException {
      Fluttertoast.showToast(
        msg: "Network error. Please check your internet connection.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "Request timed out. Please try again later.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: ${e.toString()}",
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

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); // Force prompt

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        bool userExists = await _checkIfUserExists(user.uid);

        if (userExists == false) {
          // First time user
          await _saveUserToFirestore(user);
          _navigateToLocationRequestScreen(context);
        } else {
          _navigateToHome(context);
        }
      }
      return user;
    } catch (e) {
      print("Google sign-in failed: $e");
      return null;
    }
  }

  void _navigateToLocationRequestScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationRequestScreenClient(),
      ),
    );
  }

  Future<bool> _checkIfUserExists(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();

    final profileDoc = await _firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformation")
        .doc("profile")
        .get();

    if (userDoc.exists && profileDoc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _saveUserToFirestore(User? user) async {
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);

      // Save to main 'users' collection
      await userRef.set({
        'uid': user.uid,
        'first_name': user.displayName?.split(' ')[0] ?? '',
        'last_name': user.displayName?.split(' ')[1] ?? '',
        'third_name': user.displayName?.split(' ')[2] ?? '',
        'email': user.email ?? 'No Email',
        'provider': user.providerData.first.providerId,
        'role': 'Client',
        'phone': user.phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: false));

      await _firestore
          .collection("user-files")
          .doc(user.uid)
          .collection("personalInformationProvider")
          .doc("profile")
          .set({
        "personalImageUrl": user.photoURL ?? '',
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: false));
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeClientLayout(),
      ),
    );
  }

  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login(
  //       permissions: ['email', 'public_profile'],
  //     );
  //
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //
  //       final UserCredential userCredential =
  //           await _auth.signInWithCredential(facebookAuthCredential);
  //       User? user = userCredential.user;
  //       if (user == null) return;
  //
  //       // ✅ Get the Facebook profile data, including picture
  //       final userData = await FacebookAuth.instance.getUserData(
  //         fields: "name,email,picture.width(200)", // Adjust width as needed
  //       );
  //
  //       final profileImageUrl = userData["picture"]["data"]["url"];
  //
  //       // ✅ Pass profile image URL to Firestore save function
  //       bool userExists = await _checkIfUserExists(user.uid);
  //       if (!userExists) {
  //         await _saveUserToFirestoreFace(user, profileImageUrl);
  //         _navigateToLocationRequestScreen(context);
  //       } else {
  //         _navigateToHome(context);
  //       }
  //     } else {
  //       print("Facebook sign-in failed: ${result.message}");
  //     }
  //   } catch (e) {
  //     print("Facebook sign-in error: $e");
  //   }
  // }
  //
  // Future<void> _saveUserToFirestoreFace(
  //     User? user, String profileImageUrl) async {
  //   if (user != null) {
  //     final userRef = _firestore.collection('users').doc(user.uid);
  //
  //     await userRef.set({
  //       'uid': user.uid,
  //       'first_name': user.displayName?.split(' ')[0] ?? '',
  //       'last_name': user.displayName?.split(' ')[1] ?? '',
  //       'third_name': user.displayName?.split(' ')[2] ?? '',
  //       'email': user.email ?? 'No Email',
  //       'provider': user.providerData.first.providerId,
  //       'role': 'Client',
  //       'phone': user.phoneNumber ?? '',
  //       'createdAt': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: false));
  //
  //     await _firestore
  //         .collection("user-files")
  //         .doc(user.uid)
  //         .collection("personalInformation")
  //         .doc("profile")
  //         .set({
  //       "personalImageUrl": profileImageUrl,
  //       "updatedAt": FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: false));
  //   }
  // }

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
                  style: GoogleFonts.cantataOne(
                    fontSize: 20,
                    color: ApplicationColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
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
                const SizedBox(width: 5),
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
            const SizedBox(height: 10),
            Column(
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
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          signInWithGoogle(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFAEAEAE)),
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
                                "Continue With Google",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: const Color(0xFF828282)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       signInWithFacebook(context);
                    //     },
                    //     child: Container(
                    //       padding: const EdgeInsets.all(14),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border: Border.all(color: const Color(0xFFAEAEAE)),
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const FaIcon(
                    //             FontAwesomeIcons.facebook,
                    //             color: Color(0xFF1877F2),
                    //             size: 28,
                    //           ),
                    //           const SizedBox(width: 10),
                    //           Text(
                    //             "Facebook",
                    //             style: GoogleFonts.inter(
                    //                 fontSize: 16,
                    //                 color: const Color(0xFF828282)),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
