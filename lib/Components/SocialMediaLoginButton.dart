import 'package:flutter/material.dart';

class SocialMediaLoginButton extends StatelessWidget {
  final String imagePath;
  final Function() onTap;

  SocialMediaLoginButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}