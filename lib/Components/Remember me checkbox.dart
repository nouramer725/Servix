import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constents/constent.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const RememberMeCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: ApplicationColor,
          onChanged: onChanged,
        ),
        Text(
          "Remember Me".tr(),
          style: GoogleFonts.charisSil(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
