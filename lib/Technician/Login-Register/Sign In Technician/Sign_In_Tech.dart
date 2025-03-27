import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'SignIn Form Tech.dart';

class SignInTechnician extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  context.locale.languageCode == 'ar'
                      ? "assets/images/sign/inArabic.png"
                      : "assets/images/sign/in.png",
                  width: 502,
                ),
              ),
            ),
            SignInFormTech(),
          ],
        ),
      ),
    );
  }
}
