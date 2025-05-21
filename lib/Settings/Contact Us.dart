import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/constents/constent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Components/TextField for Contact us.dart';
import '../Components/phone for contact us.dart';
import '../Theme/Theme_Provider.dart';

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
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Contact Us".tr(),
            style: GoogleFonts.cantataOne(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final message = Uri.encodeComponent(
                              "Hello, I’d like to ask about...");
                          final url = Uri.parse(
                              "https://wa.me/201281231790?text=$message");

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch WhatsApp chat';
                          }
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade200,
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
                                const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Color(0xFF25d366),
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "01274554479",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () async {
                          final Uri callUri =
                              Uri(scheme: 'tel', path: '034204514');
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          } else {
                            print('Could not launch $callUri');
                          }
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.grey.shade400
                                : Colors.white,
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
                                Icon(
                                  Icons.phone,
                                  color: ApplicationColor,
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "034204514",
                                  style: GoogleFonts.inter(
                                      fontSize: 14, color: ApplicationColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      FontAwesomeIcons.facebookF,
                      "https://firebase.flutter.dev/docs/auth/social/",
                      [
                        const Color(0xFF1877F2), // Facebook Blue
                        const Color(0xFF0A66C2), // Slightly darker Blue
                      ],
                    ),
                    const SizedBox(width: 10),
                    _buildSocialIcon(
                      FontAwesomeIcons.instagram,
                      "https://firebase.flutter.dev/docs/auth/social/",
                      [
                        const Color(0xFFFEDA75), // Yellow
                        const Color(0xFFFA7E1E), // Orange
                        const Color(0xFFD62976), // Pink
                        const Color(0xFF962FBF), // Purple
                        const Color(0xFF4F5BD5), // Blue
                      ],
                    ),
                    const SizedBox(width: 10),
                    _buildSocialIcon(
                      FontAwesomeIcons.xTwitter,
                      "https://firebase.flutter.dev/docs/auth/social/",
                      [
                        const Color(0xFF000000), // Black
                        const Color(0xFF000000), // Black
                      ],
                    ),
                    const SizedBox(width: 10),
                    _buildSocialIcon(
                      FontAwesomeIcons.tiktok,
                      "https://firebase.flutter.dev/docs/auth/social/",
                      [
                        const Color(0xFF000000), // Black
                        const Color(0xFF000000), // Black
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? const Color(0xFF333739)
                          : Colors.white,
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
                            themeProvider: themeProvider,
                          ),
                          countryCodePhoneFieldContactUs(
                            controller: _PhoneController,
                            errorText: _phoneError,
                            themeProvider: themeProvider,
                          ),
                          _buildTextField("Write your Message here".tr(),
                              controller: _messageController,
                              errorText: _messageError,
                              themeProvider: themeProvider,
                              maxLines: 5),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GradientButton(
              onPressed: () async {
                setState(() {
                  _messageError = _messageController.text.isEmpty
                      ? "Message is required".tr()
                      : null;
                  _userNameError = _UserNameController.text.isEmpty
                      ? "User Name is required".tr()
                      : null;
                  _phoneError = _PhoneController.text.isEmpty
                      ? "Phone number is required".tr()
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
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColorWithOpacity,
                    textColor: Colors.white,
                    fontSize: 15.0,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Message sent successfully!".tr(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 15.0,
                  );

                  User? user = FirebaseAuth.instance.currentUser;
                  String userId = user!.uid;
                  await FirebaseFirestore.instance
                      .collection("ContactUs")
                      .doc(userId)
                      .set({
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
            )));
  }

  Widget _buildSocialIcon(
      IconData icon, String url, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn, // Ensures the gradient applies correctly
        child: FaIcon(
          icon,
          size: 40,
          color: Colors.white, // Keep white so ShaderMask applies the gradient
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText, {
    int maxLines = 10,
    required TextEditingController controller,
    String? errorText, // Add error text parameter
    required ThemeProvider themeProvider,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done, // Show "Done" button on keyboard
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            GoogleFonts.castoro(color: Colors.grey.shade400, fontSize: 18),
        filled: true,
        fillColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        errorText: errorText, // Display error text if not null
        errorStyle: GoogleFonts.castoro(
          color: Colors.redAccent,
          fontSize: 14, // Error text style
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xE0E8E6E6), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.redAccent, width: 1), // Error border
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.redAccent, width: 1), // Focused error border
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
