import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Verification%20Email.dart';
import '../../../Components/Buttons.dart';
import '../../../Components/Country Code and Phone Number.dart';
import '../../../Components/Gender Dropdown.dart';
import '../../../Components/TextFormFiels_SignUp.dart';
import '../../../constents/constent.dart';
import '../../Home/HomeLayoutClient.dart';
import '../LocationClient/Access_Location1.dart';
import '../Sign In/Sign_In_Client.dart';

class SignUpClient extends StatefulWidget {
  @override
  _SignUpClientState createState() => _SignUpClientState();
}

class _SignUpClientState extends State<SignUpClient> {
  final TextEditingController _FirstNameController = TextEditingController();
  final TextEditingController _LastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController =
      TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? gender;
  String? role = "Client";
  var _obscureText = true;
  var _obscureConfirmText = true;

  String? _LnameError;
  String? _FnameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _phoneError;

  bool _isLoading = false;

  void _validateAndSubmit() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
      _phoneError = null;
      _LnameError = null;
      _FnameError = null;
    });

    bool isValid = true;

    // Email Validation
    if (!_emailController.text.contains(RegExp(r'\S+@\S+\.\S+'))) {
      setState(() {
        _emailError = "Please Enter a valid email address".tr();
      });
      isValid = false;
    }

    // Password Validation
    String password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password".tr();
      });
      isValid = false;
    } else if (password.length < 8) {
      setState(() {
        _passwordError = "Password must be at least 8 characters long".tr();
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      setState(() {
        _passwordError =
            "Password must contain at least one uppercase letter".tr();
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      setState(() {
        _passwordError =
            "Password must contain at least one lowercase letter".tr();
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*\d)').hasMatch(password)) {
      setState(() {
        _passwordError = "Password must contain at least one digit".tr();
      });
      isValid = false;
    } else if (!RegExp("^(?=.*[@#%^&+=])").hasMatch(password)) {
      setState(() {
        _passwordError =
            "Password must include at least one special character (e.g. ! @ # \$ % ^ & *)"
                .tr();
      });
      isValid = false;
    }

    // Confirm Password Validation
    if (_ConfirmpasswordController.text.isEmpty) {
      setState(() {
        _confirmError = "Please confirm your password".tr();
      });
      isValid = false;
    } else if (_passwordController.text != _ConfirmpasswordController.text) {
      setState(() {
        _confirmError = "Passwords do not match".tr();
      });
      isValid = false;
    }

    // First Name Validation
    if (_FirstNameController.text.isEmpty) {
      setState(() {
        _FnameError = "Please enter your first name".tr();
      });
      isValid = false;
    }

    // Last Name Validation
    if (_LastNameController.text.isEmpty) {
      setState(() {
        _LnameError = "Please enter your last name".tr();
      });
      isValid = false;
    }

    // Phone Number Validation
    if (_PhoneNumberController.text.isEmpty) {
      setState(() {
        _phoneError = "Please enter your phone number".tr();
      });
      isValid = false;
    } else if (!RegExp(r'^\d{11}$').hasMatch(_PhoneNumberController.text)) {
      setState(() {
        _phoneError = "Phone number must be exactly 11 digits".tr();
      });
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check for network connectivity
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw FirebaseException(
            plugin: 'firebase_auth',
            message:
                'No internet connection. Please check your network settings.',
          );
        }

        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: password,
        );

        // Send verification email
        await userCredential.user?.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'first_name': _FirstNameController.text.trim(),
          'last_name': _LastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _PhoneNumberController.text.trim(),
          'gender': gender?.trim(),
          'role': role,
          'created_at': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(
              email: _emailController.text.trim(),
              password: password,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: "Authentication error: ${e.message}".tr(),
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "Network error. Please check your connection.".tr(),
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "An unexpected error occurred. Please try again.".tr(),
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
        'email': user.email ?? 'No Email',
        'provider': user.providerData.first.providerId,
        'role': 'Client',
        'phone': user.phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: false));

      await _firestore
          .collection("user-files")
          .doc(user.uid)
          .collection("personalInformation")
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

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        User? user = userCredential.user;
        if (user == null) return;

        // ✅ Get the Facebook profile data, including picture
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)", // Adjust width as needed
        );

        final profileImageUrl = userData["picture"]["data"]["url"];

        // ✅ Pass profile image URL to Firestore save function
        bool userExists = await _checkIfUserExists(user.uid);
        if (!userExists) {
          await _saveUserToFirestoreFace(user, profileImageUrl);
          _navigateToLocationRequestScreen(context);
        } else {
          _navigateToHome(context);
        }
      } else {
        print("Facebook sign-in failed: ${result.message}");
      }
    } catch (e) {
      print("Facebook sign-in error: $e");
    }
  }

  Future<void> _saveUserToFirestoreFace(
      User? user, String profileImageUrl) async {
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);

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
          .collection("personalInformation")
          .doc("profile")
          .set({
        "personalImageUrl": profileImageUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: false));
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        context.locale.languageCode == 'ar'
                            ? "assets/images/sign/upArabic.png"
                            : "assets/images/sign/up.png",
                        alignment: Alignment.topLeft,
                        width: 502,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        customTextField(
                          controller: _FirstNameController,
                          keyboardTypee: TextInputType.name,
                          labelText: "First Name".tr(),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          errorText: _FnameError,
                        ),
                        customTextField(
                          controller: _LastNameController,
                          keyboardTypee: TextInputType.name,
                          labelText: "Last Name".tr(),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          errorText: _LnameError,
                        ),
                        customTextField(
                          controller: _emailController,
                          keyboardTypee: TextInputType.emailAddress,
                          labelText: "Email".tr(),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.black),
                          errorText: _emailError,
                        ),
                        customTextField(
                          controller: _passwordController,
                          keyboardTypee: TextInputType.visiblePassword,
                          labelText: "Password".tr(),
                          obscureText: _obscureText,
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.black),
                          errorText: _passwordError,
                          onVisibilityToggle: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        customTextField(
                          controller: _ConfirmpasswordController,
                          keyboardTypee: TextInputType.visiblePassword,
                          labelText: "Confirm Password".tr(),
                          obscureText: _obscureConfirmText,
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.black),
                          errorText: _confirmError,
                          onVisibilityToggle: () {
                            setState(() {
                              _obscureConfirmText = !_obscureConfirmText;
                            });
                          },
                        ),
                        countryCodePhoneField(
                          controller: _PhoneNumberController,
                          errorText: _phoneError,
                        ),
                        genderDropdown(
                          selectedValue: gender,
                          onChanged: (newValue) {
                            setState(() {
                              gender = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        GradientButton(
                          onPressed: _isLoading ? null : _validateAndSubmit,
                          text: "Sign Up".tr(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Already have an account? ".tr(),
                                style: GoogleFonts.charisSil(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInClient()),
                                );
                              },
                              child: Text(
                                " SignIn".tr(),
                                style: GoogleFonts.charisSil(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ApplicationColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: Color(0xFFD6D6D6))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "or signup by".tr(),
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF898989),
                                        fontSize: 12),
                                  ),
                                ),
                                const Expanded(
                                    child: Divider(color: Color(0xFFD6D6D6))),
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
                                        border: Border.all(
                                            color: const Color(0xFFAEAEAE)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      signInWithFacebook(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color(0xFFAEAEAE)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
