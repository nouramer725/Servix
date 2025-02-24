import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Login-Register/Sign_In.dart';
import '../Components/Buttons.dart';

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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.37),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),  //This moves the shadow 4 pixels downward.
                        )
                      ]),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to SignIn when onboarding is finished.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    }, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tr("Technician"),
                        style: GoogleFonts.charisSil(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GradientButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                }, text: tr("Client"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
