import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization
import '../../Components/Buttons.dart';
import '../../Components/Country Code and Phone Number.dart';
import '../../Components/Gender Dropdown.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormFiels_SignUp.dart';
import '../Home.dart';
import '../../Components/AuthService_Google.dart';
import 'Sign_In_Client.dart';

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

  final AuthService _authService = AuthService();

  String? gender;
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
            "Password must contain at least_one lowercase letter".tr();
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
            "Password must contain at least one special character".tr();
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
    } else if (!RegExp(r'^\+?[0-9]{7,15}$')
        .hasMatch(_PhoneNumberController.text)) {
      setState(() {
        _phoneError = "Enter a valid phone number".tr();
      });
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      try {
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
          'created_at': Timestamp.now(),
        });

        // Show popup dialog asking the user to verify their email
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Image.asset(
                    "assets/images/sign/popUpMessage.png",
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text("Email Verification".tr()),
                ],
              ),
              content: Container(
                child: Text(
                  tr("Sign Up Successful! Please check your email and verify your account."),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok".tr(),
                      style: TextStyle(color: Color(0xFF9A2B2B))),
                ),
              ],
            );
          },
        );

        // Navigate to the SignIn page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInClient()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "").tr()),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Image.asset(
                  context.locale.languageCode == 'ar'
                      ? "assets/images/sign/upArabic.png"
                      : "assets/images/sign/up.png",
                  alignment: Alignment.topLeft,
                  width: 502,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
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
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      errorText: _emailError,
                    ),
                    customTextField(
                      controller: _passwordController,
                      keyboardTypee: TextInputType.visiblePassword,
                      labelText: "Password".tr(),
                      obscureText: _obscureText,
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                            try {
                              User? user =
                                  await _authService.signInWithGoogle();
                              if (user != null) {
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
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
            ],
          ),
        ),
      ),
    );
  }
}
