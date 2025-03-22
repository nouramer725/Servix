import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../Theme/Theme_Provider.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy".tr(),
          style: GoogleFonts.cantataOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black
          ),
        ),
      ),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.castoro(
                        fontSize: 12,
                          color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black
                      ),
                      children: [
                        TextSpan(
                          text: 'The SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' application is considered a link between customers and service providers without any legal, physical or financial responsibility.\n'
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'We are not responsible '.tr(),
                        ),
                        TextSpan(
                          text:
                              'for the quality of service provided by service providers to customers required using the '
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' application or the service and do not bear responsibility in this aspect, provided that the '
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'has the right to review this.\n'.tr(),
                        ),
                        TextSpan(
                          text: 'The SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'is not responsible for any acts, actions, behavior or negligence, or all of the above, on the part of the service providers.\n'
                                  .tr(),
                        ),
                        TextSpan(
                          text:
                              'Any complaints about service providers submitted by customers should be submitted to the '
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'directly, provided that it does not bear any responsibility in this aspect, and is only a link between the two parties.\n'
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'has the right to provide any information to official authorities if requested to do so.\n'
                                  .tr(),
                        ),
                        TextSpan(
                          text: 'The SERVIX '.tr(),
                          style: GoogleFonts.calistoga(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' application does not take any commission or sum of money from the service requester in any way.\n'
                                  .tr(),
                        ),
                        TextSpan(
                          text:
                              'Fees for obtaining applications are paid by service providers only, through bank transfer only or charging a balance.\n'
                                  .tr(),
                        ),
                      ],
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
