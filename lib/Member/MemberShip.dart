import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Login-Register/Sign%20In/Sign_In_Client.dart';
import 'package:servix/Technician/Login-Register/Sign%20In%20Technician/Sign_In_Tech.dart';
import '../Components/Buttons.dart';
import '../Components/White Buttons.dart';

class MemberShip extends StatelessWidget {
  const MemberShip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lang-member/langmem.png",
                  width: 191,
                  height: 196,
                ),
                const SizedBox(
                  height: 115,
                ),
                Text(
                  tr("Select MemberShip"),
                  style: GoogleFonts.castoro(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                WhiteButton(
                  text: "Technician",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInTechnician()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GradientButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInClient()),
                      );
                    },
                    text: tr("Client"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
