import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormField_SignIn.dart';
import '../Home.dart';
import 'AuthService_Google.dart';
import 'Sign_Up.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndSubmit() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true; // Show the red CircularProgressIndicator
    });

    bool isValid = true;

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "Please enter your email";
        _isLoading = false;
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password";
        _isLoading = false;
      });
      isValid = false;
    }

    if (isValid) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await Future.delayed(const Duration(seconds: 3)); // Wait for 1 second before navigating

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  Home()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${e.message}", style: const TextStyle(color: Colors.red))),
        );
      }

      setState(() {
        _isLoading = false; // Hide the loader
      });
    }
  }


  // Future<void> loginWithFacebook() async {
  //   // Request the email permission
  //   final LoginResult result = await FacebookAuth.instance.login(
  //     permissions: ['email'], // Explicitly request the email permission
  //   );
  //
  //   if (result.status == LoginStatus.success) {
  //     // Logged in successfully, you can retrieve user data
  //     final userData = await FacebookAuth.instance.getUserData();
  //     print("Logged in as: ${userData['name']}");
  //     print("User email: ${userData['email']}");
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  //
  //   } else {
  //     // Handle login error
  //     print("Login failed: ${result.status}");
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Image.asset(
                  "assets/images/sign/in.png",
                  alignment: Alignment.topLeft,
                  width: 502,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: "Email",
                      controller: _emailController,
                      icon: Icons.email,
                      errorText: _emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 17),
                    CustomTextFormField(
                      label: "Password",
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
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: const Color(0xFF9A2B2B),
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text(
                          "Remember Me",
                          style: GoogleFonts.charisSil(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    GradientButton(
                      onPressed: _isLoading ? null : _validateAndSubmit,
                      text: "Sign In",
                      isLoading: _isLoading, // Pass loading state
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Don't have an account? ",
                            style: GoogleFonts.charisSil(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis, // Prevents overflow
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Text(
                            "SignUp",
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
                        // SocialMediaLoginButton(
                        //   imagePath: 'assets/images/social_media/facebook.png',
                        //   onTap: () async {
                        //     await loginWithFacebook();
                        //   },
                        // ),
                        const SizedBox(width: 20),
                        SocialMediaLoginButton(
                          imagePath: 'assets/images/social_media/google.png',
                          onTap: () async {
                            User? user = await _authService.signInWithGoogle();
                            if (user != null) {
                              print("Signed in as: ${user.displayName}");
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home()));

                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
