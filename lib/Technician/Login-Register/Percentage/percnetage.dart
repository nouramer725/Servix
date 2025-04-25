import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';
import '../../../constents/constent.dart';

class Percentage extends StatefulWidget {
  const Percentage({super.key});

  @override
  State<Percentage> createState() => _PercentageState();
}

class _PercentageState extends State<Percentage> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  width: 160,
                  height: 166,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Commission Information".tr(),
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
                  "As a technician using our platform, you agree that 10% of the total service fee you receive from a customer will be deducted as a commission for the app.".tr(),
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    color: ApplicationColor3,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Application Policies".tr(),
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
                  "1) You must provide accurate and honest service to customers.".tr(),
                  "2) You are responsible for showing up on time and maintaining professionalism.".tr(),
                  "3) Misuse of the app or customer information is prohibited.".tr(),
                  "4) Violations of policy may result in suspension or termination from the platform.".tr(),
                  "5) The technician must transfer the commission (10% of the service fee) to the company’s designated bank account on a monthly basis.".tr(),
                  "6) A grace period of 5 days is provided after the end of each month.".tr(),
                  "7) Failure to comply with the commission payment terms may result in suspension or termination of the technician’s account.".tr(),
                ].map((policy) => Text(
                      policy,
                      style: GoogleFonts.castoro(
                        fontSize: 16,
                        color: ApplicationColor3,
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: ApplicationColor,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "I have read and accept the above policies".tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 17,
                          color: ApplicationColor3,
                        ),
                      ),
                    ),
                  ],
                ),
                GradientButton(
                  onPressed: () {
                    if (isChecked) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingScreen(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "You must accept the policies to continue.".tr(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  text: "Continue".tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
