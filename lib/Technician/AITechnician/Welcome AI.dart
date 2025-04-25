import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:servix/Technician/AITechnician/chat.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/constents/constent.dart';

import '../../Components/Buttons.dart';

class WelcomeAiTech extends StatefulWidget {
  @override
  _WelcomeAiTechState createState() => _WelcomeAiTechState();
}

class _WelcomeAiTechState extends State<WelcomeAiTech> {
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
                        builder: (context) => const HomeTechnicianLayout()),
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
                "Knock, knock… Who’s there? 👀".tr(),
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
                "It’s me, your AI assistant! Ready to make magic happen? ✨".tr(),
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
                          builder: (context) => const ChatScreenTechnician()));
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
