import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String? _phoneError;

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
                          keyboardTypee: TextInputType.name,
                          labelText: "User Name".tr(),
                        ),
                        countryCodePhoneFieldContactUs(
                          controller: _PhoneController,
                          errorText: _phoneError,
                        ),
                        _buildTextField("Write your Message here".tr(),
                            maxLines: 5),
                      ],
                    ),
                  )),
              SizedBox(
                height: 25,
              ),
              GradientButton(onPressed: () {}, text: "Send".tr())
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

  Widget _buildTextField(String hintText, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            GoogleFonts.castoro(color: Colors.grey.shade400, fontSize: 18),
        filled: true,
        fillColor: Colors.white,
        enabledBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10), // Increased rounded corners
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10), // Increased rounded corners
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
