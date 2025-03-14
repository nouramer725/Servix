import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SignInHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Image.asset(
          context.locale.languageCode == 'ar'
              ? "assets/images/sign/inArabic.png"
              : "assets/images/sign/in.png",
          alignment: Alignment.topLeft,
          width: 502,
        ),
      ),
    );
  }
}
