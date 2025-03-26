import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:servix/Theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servix/Client/Home/Home.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import 'package:servix/Language/Language.dart';
import 'package:servix/On-Boarding/On_Boarding_Screen.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/Technician/Login-Register/Sign%20In%20Technician/Sign_In_Tech.dart';
import 'package:servix/Technician/Login-Register/SignUP/Sign_Up_Tech.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';
import 'Client/Home/HomeLayoutClient.dart';
import 'Client/Login-Register/Sign In/Sign_In_Client.dart';
import 'Language/Local_Provider.dart';
import 'Theme/Theme_Provider.dart';
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
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()), // Add this
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lighttheme,
            darkTheme: darktheme,
            themeMode: themeProvider.themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: {
              "/": (context) => const CheckUserState(),
              "/onboarding": (context) => const OnboardingScreen(),
              "/signinChoice": (context) => const Language(),
              "/signinClient": (context) => SignInClient(),
              "/signinTech": (context) => SignInTechnician(),
              "/signupClient": (context) => SignUpClient(),
              "/signupTech": (context) => SignUpTechnician(),
              "/clientHome": (context) => const HomeClientLayout(),
              "/techHome": (context) => const HomeTechnicianLayout(),
              "/waiting": (context) => WaitingScreen(),
            },
          ),
        );
      },
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
