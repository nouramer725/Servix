import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servix/Client/Home.dart';
import 'package:servix/Client/Login-Register/Sign_Up_Client.dart';
import 'package:servix/Language/Language.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:servix/On-Boarding/On_Boarding_Screen.dart';
import 'package:servix/Technician/Home/HomeTechnician.dart';
import 'package:servix/Technician/Login-Register/Sign_In_Tech.dart';
import 'package:servix/Technician/Login-Register/Sign_Up_Tech.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Client/Login-Register/Sign_In_Client.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/Translation', // translation files path
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
            routes: {
              "/": (context) => CheckUserState(),
              "/onboarding": (context) => OnboardingScreen(),
              "/signinChoice": (context) => Language(), // Choose Client or Tech
              "/signinClient": (context) => SignInClient(),
              "/signinTech": (context) => SignInTechnician(),
              "/signupClient": (context) => SignUpClient(),
              "/signupTech": (context) => SignUpTechnician(),
              "/clientHome": (context) => Home(),
              "/techHome": (context) => HomeTechnician(),
            }
        )
    );
  }
}
class CheckUserState extends StatefulWidget {
  const CheckUserState({super.key});

  @override
  State<CheckUserState> createState() => _CheckUserStateState();
}

class _CheckUserStateState extends State<CheckUserState> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? seenOnboarding = prefs.getBool("seenOnboarding");
    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 2));

    if (seenOnboarding == null || !seenOnboarding) {
      prefs.setBool("seenOnboarding", true);
      Navigator.pushReplacementNamed(context, "/onboarding");
    } else if (user == null) {
      Navigator.pushReplacementNamed(context, "/signinChoice"); // Choose client or tech
    } else {
      // ✅ Get user type from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc["userType"];
        if (userType == "client") {
          Navigator.pushReplacementNamed(context, "/clientHome");
        } else {
          Navigator.pushReplacementNamed(context, "/techHome");
        }
      } else {
        Navigator.pushReplacementNamed(context, "/signinChoice");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
