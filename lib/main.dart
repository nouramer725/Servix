import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:servix/Client/Home.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import 'package:servix/Language/Language.dart';
import 'package:servix/On-Boarding/On_Boarding_Screen.dart';
import 'package:servix/Technician/Login-Register/Sign%20In%20Technician/Sign_In_Tech.dart';
import 'package:servix/Technician/Login-Register/SignUP/Sign_Up_Tech.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Client/Login-Register/Sign In/Sign_In_Client.dart';
import 'Technician/Home/HomeTechnician.dart';
import 'constents/constent.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
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
              "/waiting": (context) => WaitingScreen()
            }));
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
      Navigator.pushNamedAndRemoveUntil(
          context, "/onboarding", (route) => false);
      return;
    }

    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/signinChoice", (route) => false);
      return;
    }

    // Check if user exists in "technician" collection
    DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(user.uid)
        .get();

    if (technicianDoc.exists) {
      final data = technicianDoc.data() as Map<String, dynamic>?;

      String status = data?['status'] ?? 'pending';

      if (status == "approved") {
        // ✅ Always navigate to HomeTechnician if approved
        Navigator.pushNamedAndRemoveUntil(
            context, "/techHome", (route) => false);
      } else {
        // ❌ Stay on WaitingScreen if rejected or pending
        Navigator.pushNamedAndRemoveUntil(
            context, "/waiting", (route) => false);
      }
      return;
    }

    // If not a technician, check if user exists in "users" collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      // If user exists in "users" collection, go to Home screen
      Navigator.pushNamedAndRemoveUntil(
          context, "/clientHome", (route) => false);
      return;
    }

    // If user is not found in either collection, log them out & send to sign-in choice
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, "/signinChoice", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: ApplicationColor,
      )),
    );
  }
}
