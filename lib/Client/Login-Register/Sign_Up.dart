import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Home.dart';
import 'package:servix/Client/Login-Register/Sign_In.dart';
import '../../Components/Buttons.dart';
import '../../Components/Country Code and Phone Number.dart';
import '../../Components/Gender Dropdown.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormFiels_SignUp.dart';
import 'AuthService_Google.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  bool _isLoading = false; // Add this at the class level

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
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "Please enter your email";
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
    } else if (!RegExp(r'^\+?[0-9]{7,15}$')
        .hasMatch(_PhoneNumberController.text)) {
      setState(() {
        _phoneError = "Enter a valid phone number";
      });
      isValid = false;
    }

    // If all validations pass, proceed with Firebase Authentication
    if (isValid) {
      setState(() {
        _isLoading = true; // Show CircularProgressIndicator instead of button
      });

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: password,
        );

        // Send email verification
        await userCredential.user?.sendEmailVerification();

        // Store user data in Firestore
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                "Sign Up Successful! Check your email for verification.",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
        );

        // Continuously check for email verification
        User? user = FirebaseAuth.instance.currentUser;
        while (user != null && !user.emailVerified) {
          await Future.delayed(
              Duration(seconds: 3)); // Wait 3 seconds before checking again
          await user.reload(); // Refresh user data
          user = FirebaseAuth.instance.currentUser;
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading spinner
        });
      }
    }
  }

  // Future<void> loginWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login(
  //     permissions: ['email'], // Explicitly request the email permission
  //   );
  //
  //   if (result.status == LoginStatus.success) {
  //     final userData = await FacebookAuth.instance.getUserData();
  //     print("Logged in as: ${userData['name']}");
  //     print("User email: ${userData['email']}");
  //   } else {
  //     print("Login failed: ${result.status}");
  //   }
  // }

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
                      text: "Verify",
                      isLoading: _isLoading, // Pass loading state
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Already have an account? ",
                            style: GoogleFonts.charisSil(
                              fontSize: 20,
                            ),
                            overflow:
                            TextOverflow.ellipsis, // Prevents overflow
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SocialMediaLoginButton(
                        //     imagePath: 'assets/images/social_media/facebook.png',
                        //     onTap: () async {
                        //       await loginWithFacebook();
                        //     }
                        // ),
                        SizedBox(width: 20),
                        SocialMediaLoginButton(
                          imagePath: 'assets/images/social_media/google.png',
                          onTap: () async {
                            try {
                              User? user = await _authService.signInWithGoogle();
                              if (user != null) {
                                // Navigate only if user is not null
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
