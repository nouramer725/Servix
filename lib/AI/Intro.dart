import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import '../Theme/Theme_Provider.dart';
import 'chat.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Lottie.asset(
                  'assets/Application/ChatAi.json', // Path to your Lottie file
                  height: 350,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Meet Your Virtual Assistant!".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 35,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "It's a pleasure to meet you! How can i assist you today?".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: GradientButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatScreen()));
          },
          text: "Start a Conversation".tr(), // Fun button text
        ),
      ),
    );
  }
}
