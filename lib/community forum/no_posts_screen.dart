import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Theme/Theme_Provider.dart';

class NoPostsScreen extends StatefulWidget {
  const NoPostsScreen({super.key});

  @override
  State<NoPostsScreen> createState() => _NoPostsScreenState();
}

class _NoPostsScreenState extends State<NoPostsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/Application/community.json',
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
              Text(
                'No Community Discussions Yet!'.tr(),
                style: GoogleFonts.castoro(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Once users start posting, you’ll see community discussions here.'
                    .tr(),
                style: GoogleFonts.castoro(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
