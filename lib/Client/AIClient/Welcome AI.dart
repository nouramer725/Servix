import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/Buttons.dart';
import 'chat.dart';

class WelcomeAiClient extends StatefulWidget {
  @override
  _WelcomeAiClientState createState() => _WelcomeAiClientState();
}

class _WelcomeAiClientState extends State<WelcomeAiClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.close, color: ApplicationColor, size: 35),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeClientLayout()),
                    (route) => false,
                  );
                }),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
              const SizedBox(height: 40),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatScreenClient()));
                },
                text: "Start a Conversation".tr(), // Fun button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
