import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:servix/constents/constent.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ApplicationColor, // Deep red
              ApplicationColor4, // Lighter red
              ApplicationColor3, // Darker red
            ],
            stops: [0.09, 0.45, 1.0],
          ),
        ),
        child: SizedBox.expand(
          child: Lottie.asset(
            'assets/Application/finalbgdddd.json',
            fit: BoxFit.fitWidth,
            repeat: false,
            animate: true,
          ),
        ),
      ),
    );
  }
}
