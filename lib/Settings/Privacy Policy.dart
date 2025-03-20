import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Privacy Policy",
            style: GoogleFonts.cantataOne(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
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
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.30),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: Offset(5, 5),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.castoro(
                            fontSize: 12, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'The SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ' application is considered a link between customers and service providers without any legal, physical or financial responsibility.\n',
                          ),
                          TextSpan(
                            text: 'We are not responsible ',
                          ),
                          TextSpan(
                            text:
                                'for the quality of service provided by service providers to customers required using the ',
                          ),
                          TextSpan(
                            text: 'SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ' application or the service and do not bear responsibility in this aspect, provided that the ',
                          ),
                          TextSpan(
                            text: 'SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'has the right to review this.\n',
                          ),
                          TextSpan(
                            text: 'The SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'is not responsible for any acts, actions, behavior or negligence, or all of the above, on the part of the service providers.\n',
                          ),
                          TextSpan(
                            text:
                                'Any complaints about service providers submitted by customers should be submitted to the ',
                          ),
                          TextSpan(
                            text: 'SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'directly, provided that it does not bear any responsibility in this aspect, and is only a link between the two parties.\n',
                          ),
                          TextSpan(
                            text: 'SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'has the right to provide any information to official authorities if requested to do so.\n',
                          ),
                          TextSpan(
                            text: 'The SERVIX ',
                            style: GoogleFonts.calistoga(
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ' application does not take any commission or sum of money from the service requester in any way.\n',
                          ),
                          TextSpan(
                            text:
                                'Fees for obtaining applications are paid by service providers only, through bank transfer only or charging a balance.\n',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
