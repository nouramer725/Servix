import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';
import '../../../constents/constent.dart';

class PercentageSide extends StatefulWidget {
  const PercentageSide({super.key});

  @override
  State<PercentageSide> createState() => _PercentageSideState();
}

class _PercentageSideState extends State<PercentageSide> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Technician Policy".tr(),
          style: GoogleFonts.cantataOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          maxLines: 2,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/lang-member/langmem.png",
                  width: 191,
                  height: 196,
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Commission Information",
                    style: GoogleFonts.castoro(
                      fontSize: 20,
                      color: ApplicationColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: ApplicationColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "As a technician using our platform, you agree that 10% of the total service fee you receive from a customer will be deducted as a commission for the app.",
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    color: ApplicationColor3,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Application Policies",
                    style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ApplicationColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...[
                  "1) You must provide accurate and honest service to customers.",
                  "2) You are responsible for showing up on time and maintaining professionalism.",
                  "3) Misuse of the app or customer information is prohibited.",
                  "4) Violations of policy may result in suspension or termination from the platform.",
                  "5) The technician must transfer the commission (10% of the service fee) to the company’s designated bank account on a monthly basis.",
                  "6) A grace period of 5 days is provided after the end of each month.",
                  "7) Failure to comply with the commission payment terms may result in suspension or termination of the technician’s account.",
                ].map((policy) => Text(
                  policy,
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    color: ApplicationColor3,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
