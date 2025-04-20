import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/Technician/Login-Register/Personal%20Info/Personal%20Info%20tech.dart';
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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<User?> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final googleSignIn = GoogleSignIn();
  //     await googleSignIn.signOut(); // Force prompt
  //
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) return null;
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       bool userExists = await _checkIfUserExists(user.uid);
  //
  //       if (userExists == false) {
  //         // First time user
  //         await _saveUserToFirestore(user);
  //         _navigateToPersonalRequestScreen(context);
  //       } else {
  //         _navigateToHome(context);
  //       }
  //     }
  //     return user;
  //   } catch (e) {
  //     print("Google sign-in failed: $e");
  //     return null;
  //   }
  // }
  //
  // void _navigateToPersonalRequestScreen(BuildContext context) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const PersonalInformation(),
  //     ),
  //   );
  // }
  //
  // Future<bool> _checkIfUserExists(String uid) async {
  //   try {
  //     final technicianDoc = await FirebaseFirestore.instance
  //         .collection('technician')
  //         .doc(uid)
  //         .get();
  //
  //     final uploadsSnapshot = await FirebaseFirestore.instance
  //         .collection("user-files")
  //         .doc(uid)
  //         .collection("uploads")
  //         .limit(1)
  //         .get();
  //
  //     // User is considered existing only if both technician doc and at least one upload exist
  //     return technicianDoc.exists && uploadsSnapshot.docs.isNotEmpty;
  //   } catch (e) {
  //     print("Error checking user existence: $e");
  //     return false;
  //   }
  // }
  //
  // Future<void> _saveUserToFirestore(User? user) async {
  //   if (user != null) {
  //     final techRef = firestore.collection('technician').doc(user.uid);
  //
  //     // Save to main 'users' collection
  //     await techRef.set({
  //       'uid': user.uid,
  //       'first_name': user.displayName?.split(' ')[0] ?? '',
  //       'last_name': user.displayName?.split(' ')[1] ?? '',
  //       'email': user.email ?? 'No Email',
  //       'provider': user.providerData.first.providerId,
  //       'role': 'Technician',
  //       'phone': user.phoneNumber ?? '',
  //       'createdAt': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: false));
  //
  //     await FirebaseFirestore.instance
  //         .collection("user-files")
  //         .doc(user.uid)
  //         .collection("uploads")
  //         .add({
  //       "personalFileUrl": user.photoURL ?? '',
  //       "updatedAt": FieldValue.serverTimestamp(),
  //     },);
  //   }
  // }
  //
  // void _navigateToHome(BuildContext context) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const HomeTechnicianLayout(),
  //     ),
  //   );
  // }

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

        if (techDoc.exists) {
          String roleTech = techDoc['role'] ?? '';

          if (roleTech == 'Technician') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeTechnicianLayout()),
            );
          } else if (roleTech == 'Client') {
            // Update role to Technician
            await techDoc.reference.update({'role': 'Technician'});

            // Navigate to technician home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeTechnicianLayout()),
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
        message = 'This email address does not exist'.tr();
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
                    fontSize: 20,
                    color: ApplicationColor,
                  ),
                ),
              ),
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
                Text(
                  "Don't have an account? ".tr(),
                  style: GoogleFonts.charisSil(fontSize: 20),
                ),
                const SizedBox(width: 5),
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
                          // signInWithGoogle(context);
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
                                "Google",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: const Color(0xFF828282)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // signInWithFacebook(context);
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
                              const FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Color(0xFF1877F2),
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Facebook",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: const Color(0xFF828282)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
