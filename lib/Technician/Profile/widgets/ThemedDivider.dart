import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Theme/Theme_Provider.dart';

class ThemedDivider extends StatelessWidget {
  const ThemedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Divider(
      color: themeProvider.themeMode == ThemeMode.dark
          ? Colors.white
          : Colors.grey[300],
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
