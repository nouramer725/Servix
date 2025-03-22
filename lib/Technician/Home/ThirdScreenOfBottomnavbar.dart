import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/Theme_Provider.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Color(0xFF333739)
          : Colors.white,
      body: Center(
        child: Text("Orders"),
      ),
    );
  }
}
