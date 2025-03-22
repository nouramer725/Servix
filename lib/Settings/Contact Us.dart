import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/constents/constent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Components/TextField for Contact us.dart';
import '../Components/phone for contact us.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  final TextEditingController _UserNameController = TextEditingController();
  final TextEditingController _PhoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _phoneError;
  String? _userNameError;
  String? _messageError;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Contact Us".tr(),
          style: GoogleFonts.cantataOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/lang-member/langmem.png",
                width: 191,
                height: 196,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/social_media/whatsapp.png",
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "+20 01121420810",
                            style: GoogleFonts.inter(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/social_media/phone.png",
                            width: 27,
                            height: 50,
                          ),
                          Text(
                            "03 4204514",
                            style: GoogleFonts.inter(
                                fontSize: 14, color: ApplicationColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon("assets/images/social_media/face.jpg",
                      "https://firebase.flutter.dev/docs/auth/social/"),
                  _buildSocialIcon("assets/images/social_media/instagram.png",
                      "https://firebase.flutter.dev/docs/auth/social/"),
                  _buildSocialIcon("assets/images/social_media/twitter.jpg",
                      "https://firebase.flutter.dev/docs/auth/social/"),
                  _buildSocialIcon("assets/images/social_media/tiktok.png",
                      "https://firebase.flutter.dev/docs/auth/social/"),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        customTextFieldContact(
                          controller: _UserNameController,
                          errorText: _userNameError,
                          keyboardTypee: TextInputType.name,
                          labelText: "User Name".tr(),
                        ),
                        countryCodePhoneFieldContactUs(
                          controller: _PhoneController,
                          errorText: _phoneError,
                        ),
                        _buildTextField("Write your Message here".tr(),
                            controller: _messageController,
                            errorText: _messageError,
                            maxLines: 5),
                      ],
                    ),
                  )),
              SizedBox(
                height: 25,
              ),
              GradientButton(
                onPressed: () async {
                  setState(() {
                    _messageError = _messageController.text.isEmpty
                        ? "Message is required"
                        : null;
                    _userNameError = _UserNameController.text.isEmpty
                        ? "User Name is required"
                        : null;
                    _phoneError = _PhoneController.text.isEmpty
                        ? "Phone number is required"
                        : null;
                  });

                  String userName = _UserNameController.text.trim();
                  String phone = _PhoneController.text.trim();
                  String message = _messageController.text
                      .trim(); // Add a controller for message

                  if (userName.isEmpty || phone.isEmpty || message.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "All fields are required".tr(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: ApplicationColorWithOpacity,
                      textColor: Colors.white,
                      fontSize: 15.0,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Message sent successfully!".tr(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 15.0,
                    );

                    User? user = FirebaseAuth.instance.currentUser;
                    String userId = user!.uid;
                    await FirebaseFirestore.instance.collection("ContactUs").doc(userId).set({
                      "userName": _UserNameController.text,
                      "phone": _PhoneController.text,
                      "message": _messageController.text,
                      "timestamp": FieldValue.serverTimestamp(),
                    });

                    // Clear fields after submission
                    _UserNameController.clear();
                    _PhoneController.clear();
                    _messageController.clear();
                  }
                },
                text: "Send".tr(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(
        assetPath,
        width: 50,
        height: 50,
      ),
    );
  }

  Widget _buildTextField(
    String hintText, {
    int maxLines = 10,
    required TextEditingController controller,
    String? errorText, // Add error text parameter
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            GoogleFonts.castoro(color: Colors.grey.shade400, fontSize: 18),
        filled: true,
        fillColor: Colors.white,
        errorText: errorText, // Display error text if not null
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1), // Error border
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.red, width: 1), // Focused error border
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
