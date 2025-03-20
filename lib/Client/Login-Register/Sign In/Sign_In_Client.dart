import 'package:flutter/material.dart';

import 'Sign In Header.dart';
import 'SignIn Form.dart';

class SignInClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SignInHeader(),
                const SizedBox(height: 50),
                SignInForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
