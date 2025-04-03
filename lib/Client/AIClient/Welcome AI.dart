import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:servix/constents/constent.dart';

class WelcomeAiClient extends StatefulWidget {
  @override
  _WelcomeAiClientState createState() => _WelcomeAiClientState();
}

class _WelcomeAiClientState extends State<WelcomeAiClient> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeClientLayout()),
        (route) => false, // Remove all previous routes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Knock, knock… Who’s there? 👀",
                  style: GoogleFonts.charisSil(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ApplicationColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Text(
                  "It’s me, your AI assistant! Ready to make magic happen? ✨",
                  style: GoogleFonts.charisSil(
                    fontSize: 25,
                    color: ApplicationColor3,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  'assets/images/intro/servix.json', // Path to your Lottie file
                  height: 430,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
