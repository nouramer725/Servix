import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../Components/Country Code and Phone Number.dart';
import '../../Components/Gender Dropdown.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormFiels_SignUp.dart';
import '../Home.dart';
import 'AuthService_Google.dart';
import 'Sign_In.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _FirstNameController = TextEditingController();
  final TextEditingController _LastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();
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
        _emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    // Password Validation
    String password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password";
      });
      isValid = false;
    } else if (password.length < 8) {
      setState(() {
        _passwordError = "Password must be at least 8 characters long";
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      setState(() {
        _passwordError = "Password must contain at least one uppercase letter";
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      setState(() {
        _passwordError = "Password must contain at least one lowercase letter";
      });
      isValid = false;
    } else if (!RegExp(r'^(?=.*\d)').hasMatch(password)) {
      setState(() {
        _passwordError = "Password must contain at least one digit";
      });
      isValid = false;
    } else if (!RegExp("^(?=.*[@#%^&+=])").hasMatch(password)) {
      setState(() {
        _passwordError = "Password must contain at least one special character";
      });
      isValid = false;
    }

    // Confirm Password Validation
    if (_ConfirmpasswordController.text.isEmpty) {
      setState(() {
        _confirmError = "Please confirm your password";
      });
      isValid = false;
    } else if (_passwordController.text != _ConfirmpasswordController.text) {
      setState(() {
        _confirmError = "Passwords do not match";
      });
      isValid = false;
    }

    // First Name Validation
    if (_FirstNameController.text.isEmpty) {
      setState(() {
        _FnameError = "Please enter your first name";
      });
      isValid = false;
    }

    // Last Name Validation
    if (_LastNameController.text.isEmpty) {
      setState(() {
        _LnameError = "Please enter your last name";
      });
      isValid = false;
    }

    // Phone Number Validation
    if (_PhoneNumberController.text.isEmpty) {
      setState(() {
        _phoneError = "Please enter your phone number";
      });
      isValid = false;
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_PhoneNumberController.text)) {
      setState(() {
        _phoneError = "Enter a valid phone number";
      });
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                  SizedBox(width: 10),
                  Text("Email Verification"),
                ],
              ),
              content: Container(
                child: const Text(
                  "Sign Up Successful! Please check your email and verify your account.",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK", style: TextStyle(color: Color(0xFF9A2B2B))),
                ),
              ],
            );
          },
        );

        // Navigate to the SignIn page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
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
                  "assets/images/sign/up.png",
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
                      labelText: "First Name",
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: _FnameError,
                    ),
                    customTextField(
                      controller: _LastNameController,
                      keyboardTypee: TextInputType.name,
                      labelText: "Last Name",
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: _LnameError,
                    ),
                    customTextField(
                      controller: _emailController,
                      keyboardTypee: TextInputType.emailAddress,
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      errorText: _emailError,
                    ),
                    customTextField(
                      controller: _passwordController,
                      keyboardTypee: TextInputType.visiblePassword,
                      labelText: "Password",
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
                      labelText: "Confirm Password",
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
                      text: "Sign UP",
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Already have an account? ",
                            style: GoogleFonts.charisSil(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
                          child: Text(
                            "SignIn",
                            style: GoogleFonts.charisSil(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9A2B2B),
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
            ],
          ),
        ),
      ),
    );
  }
}