import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Terms and Conditions".tr(),
          style: GoogleFonts.cantataOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        spreadRadius: 0.5,
                        blurRadius: 5,
                        offset: const Offset(5, 5),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.castoro(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        children: [
                          _buildBoldText("1. Acceptance of Terms\n".tr()),
                          _buildNormalText(
                              "By downloading, accessing, or using SERVIX, you agree to abide by these Terms and Conditions. If you do not agree, please do not use our services.\n"
                                  .tr()),
                          _buildBoldText("2. Services Provided\n".tr()),
                          _buildNormalText(
                              "SERVIX offers [Home, Care, Woman, Man, Devices, and Delivery Services]. We connect users with verified service providers to ensure quality and reliability.\n"
                                  .tr()),
                          _buildBoldText("3. User Accounts\n".tr()),
                          _buildNormalText(
                              "You must create an account to use our services.\n"
                                  .tr()),
                          _buildNormalText(
                              "You are responsible for maintaining the confidentiality of your login details.\n"
                                  .tr()),
                          _buildNormalText(
                              "Any misuse or unauthorized access to your account should be reported immediately.\n"
                                  .tr()),
                          _buildBoldText("4. User Responsibilities\n".tr()),
                          _buildNormalText(
                              "By using our services, you agree:\n".tr()),
                          _buildNormalText(
                              "✔️ To provide accurate information during registration and booking.\n"
                                  .tr()),
                          _buildNormalText(
                              "✔️ Not to misuse or disrupt our platform.\n"
                                  .tr()),
                          _buildNormalText(
                              "✔️ To respect our service providers and comply with local laws.\n"
                                  .tr()),
                          _buildBoldText(
                              "5. Service Provider Responsibilities\n".tr()),
                          _buildNormalText(
                              "Service providers must meet the quality standards set by SERVIX. Providers must ensure timely and professional service delivery.\n"
                                  .tr()),
                          _buildBoldText("6. Liability Disclaimer\n".tr()),
                          _buildNormalText(
                              "SERVIX acts as a platform connecting users with service providers. We are not responsible for any disputes, damages, or issues arising from service execution. We do not guarantee uninterrupted access to our services due to unforeseen circumstances."
                                  .tr()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildBoldText(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  TextSpan _buildNormalText(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.castoro(fontSize: 12),
    );
  }
}
