import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Technician/HomeTechnician.dart';
import 'package:servix/Technician/Login-Register/Personal%20Info%20tech.dart';
import 'package:servix/Technician/Login-Register/Sign_In_Tech.dart';
import '../../Components/AuthService_Google.dart';
import '../../Components/Buttons.dart';
import '../../Components/Country Code and Phone Number.dart';
import '../../Components/Gender Dropdown.dart';
import '../../Components/List of Service.dart';
import '../../Components/SocialMediaLoginButton.dart';
import '../../Components/TextFormFiels_SignUp.dart';
import '../../Components/Date of birth.dart';
import '../../Components/Services.dart';

class SignUpTechnician extends StatefulWidget {
  @override
  _SignUpTechnicianState createState() => _SignUpTechnicianState();
}

class _SignUpTechnicianState extends State<SignUpTechnician> {
  // Controllers
  final TextEditingController _FirstNameController = TextEditingController();
  final TextEditingController _LastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController =
      TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mainServiceController = TextEditingController();
  final TextEditingController _subServiceController = TextEditingController();

  // Sample data for main services and corresponding sub services
  late final List<String> mainServices;

  String? selectedMainService;
  String? selectedSubService;
  final AuthService _authService = AuthService();
  String? gender;

  // For password fields
  var _obscureText = true;
  var _obscureConfirmText = true;

  // Error variables
  String? _LnameError;
  String? _FnameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _phoneError;
  String? _dobError;
  String? _mainServiceError;
  String? _subServiceError;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize mainServices from the keys of subServicesMap
    mainServices = subServicesMap.keys.toList();
  }

  // Date Picker logic for Date of Birth
  Future<void> _pickDateOfBirth() async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18), // default to 18 years old
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF821717),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _validateAndSubmit() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
      _phoneError = null;
      _LnameError = null;
      _FnameError = null;
      _dobError = null;
      _mainServiceError=null;
      _subServiceError=null;
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
    // Date of Birth Validation
    if (_dobController.text.isEmpty) {
      setState(() {
        _dobError = "Please enter your date of birth".tr();
      });
      isValid = false;
    }

// Main Service Validation
    if (_mainServiceController.text.isEmpty ||_subServiceController.text.isEmpty) {
      setState(() {
        _mainServiceError = "Please select your services".tr();
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

        // Save data to Firestore, including date of birth and services
        await FirebaseFirestore.instance
            .collection('technician')
            .doc(userCredential.user?.uid)
            .set({
          'first_name': _FirstNameController.text.trim(),
          'last_name': _LastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _PhoneNumberController.text.trim(),
          'gender': gender?.trim(),
          'date_of_birth': _dobController.text.trim(), // Save DOB
          'main_service': selectedMainService ?? "",
          'sub_service': selectedSubService ?? "",
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
              content: Text(
                "Sign Up Successful! Please check your email and verify your account."
                    .tr(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok".tr(),
                    style: const TextStyle(color: Color(0xFF821717)),
                  ),
                ),
              ],
            );
          },
        );

        // Navigate to the SignIn page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersonalInformation()),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              // Top Image
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
              // Form Fields
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    // First Name
                    customTextField(
                      controller: _FirstNameController,
                      keyboardTypee: TextInputType.name,
                      labelText: "First Name".tr(),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: _FnameError,
                    ),
                    // Last Name
                    customTextField(
                      controller: _LastNameController,
                      keyboardTypee: TextInputType.name,
                      labelText: "Last Name".tr(),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: _LnameError,
                    ),
                    // Email
                    customTextField(
                      controller: _emailController,
                      keyboardTypee: TextInputType.emailAddress,
                      labelText: "Email".tr(),
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      errorText: _emailError,
                    ),
                    // Password
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
                    // Confirm Password
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
                    // Phone
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
                    const SizedBox(height: 17),
                    // Date of Birth
                    customDOBField(
                      controller: _dobController,
                      labelText: "Date of Birth".tr(),
                      errorText: _dobError, // If you have an error variable
                      onTap: _pickDateOfBirth, // Your function to pick the date
                    ),
                    ServicesRow(
                      mainServices: mainServices,
                      subServicesMap: subServicesMap,
                      selectedMainService: selectedMainService,
                      selectedSubService: selectedSubService,
                      mainServiceError: _mainServiceError,
                      onMainChanged: (String? newMain) {
                        setState(() {
                          selectedMainService = newMain;
                          selectedSubService =
                              null; // Reset sub service when main changes
                        });
                      },
                      onSubChanged: (String? newSub) {
                        setState(() {
                          selectedSubService = newSub;
                        });
                      },
                    ),

                    const SizedBox(height: 30),
                    // Sign Up Button
                    GradientButton(
                      onPressed: _isLoading ? null : _validateAndSubmit,
                      text: "Sign Up".tr(),
                    ),
                    const SizedBox(height: 10),
                    // Already have an account?
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
                                  builder: (context) => SignInTechnician()),
                            );
                          },
                          child: Text(
                            " SignIn".tr(),
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
                    // Social Media Buttons
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
                                        builder: (context) => HomeTechnician()),
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
