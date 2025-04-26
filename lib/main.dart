import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Login-Register/LocationTechnician/Access_Location1.dart';
import 'package:servix/Technician/Login-Register/Personal%20Info/Personal%20Info%20tech.dart';
import 'package:servix/Theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servix/Client/Login-Register/Sign%20UP/Sign_Up_Client.dart';
import 'package:servix/Language/Language.dart';
import 'package:servix/On-Boarding/On_Boarding_Screen.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:servix/Technician/Login-Register/Sign%20In%20Technician/Sign_In_Tech.dart';
import 'package:servix/Technician/Login-Register/SignUP/Sign_Up_Tech.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';
import 'Client/Home/HomeLayoutClient.dart';
import 'Client/Login-Register/LocationClient/Access_Location1.dart';
import 'Client/Login-Register/Sign In/Sign_In_Client.dart';
import 'Language/Local_Provider.dart';
import 'Splash Screen/Splash.dart';
import 'Theme/Theme_Provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance
      .subscribeToTopic("servix"); // Subscribe to topic
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken"); // Print FCM token
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
              "/splash": (context) => const SplashScreen(),
              "/onboarding": (context) => const OnboardingScreen(),
              "/signinChoice": (context) => const Language(),
              "/signinClient": (context) => SignInClient(),
              "/signinTech": (context) => SignInTechnician(),
              "/signupClient": (context) => SignUpClient(),
              "/signupTech": (context) => SignUpTechnician(),
              "/clientHome": (context) => const HomeClientLayout(),
              "/techHome": (context) => const HomeTechnicianLayout(),
              "/waiting": (context) => WaitingScreen(),
              "/locationRequest": (context) =>
                  const LocationRequestScreenClient(),
              "/locationRequesttech": (context) =>
                  const LocationRequestScreenTech(),
              "/personalInfoTech": (context) => const PersonalInformation(),
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
    bool seenOnboarding = prefs.getBool("seenOnboarding") ?? false;
    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 5));

// ✅ Only redirect to onboarding if it hasn't been seen yet
    if (!seenOnboarding) {
      await prefs.setBool("seenOnboarding", true); // mark onboarding as seen
      if (!mounted)
        return; // Avoid navigation if the widget is no longer in the widget tree
      Navigator.pushNamedAndRemoveUntil(
          context, "/onboarding", (route) => false);
      return;
    }

    // If user is not logged in, redirect to signin screen
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/signinChoice", (route) => false);
      return;
    }

    // Check if the user is a technician
    DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(user.uid)
        .get();

    if (technicianDoc.exists) {
      final data = technicianDoc.data() as Map<String, dynamic>?;

      String status = data?['status'] ?? 'pending';
      String role = data?['role'] ?? 'Technician';

      // Check if user has uploads, if not redirect to personal info screen
      QuerySnapshot uploadsSnapshot = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("uploads")
          .limit(1)
          .get();

      bool hasuploads = uploadsSnapshot.docs.isNotEmpty;

      if (!hasuploads) {
        Navigator.pushReplacementNamed(context, "/personalInfoTech");
        return;
      }

      // Check if technician has location details
      QuerySnapshot locationtechSnapshot = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("locationDetails")
          .limit(1)
          .get();

      bool hasLocationtech = locationtechSnapshot.docs.isNotEmpty;

      if (!hasLocationtech) {
        Navigator.pushReplacementNamed(context, "/locationRequesttech");
        return;
      }

      // Role-based redirection
      if (role == 'Client') {
        Navigator.pushNamedAndRemoveUntil(
            context, "/clientHome", (route) => false);
      } else if (status == "approved") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/techHome", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/waiting", (route) => false);
      }
      return;
    }

    // If user is a regular client, check user status and location details
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;

      String role = data?['role'] ?? 'Client';

      // Check if user has location details
      QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("locationDetails")
          .limit(1)
          .get();

      bool hasLocation = locationSnapshot.docs.isNotEmpty;

      if (!hasLocation) {
        // If no location details, navigate to location request screen
        Navigator.pushReplacementNamed(context, "/locationRequest");
        return;
      }

      // Role-based redirection
      if (role == 'Client') {
        Navigator.pushNamedAndRemoveUntil(
            context, "/clientHome", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/techHome", (route) => false);
      }
    } else {
      // If the user does not exist in the database, sign them out
      await FirebaseAuth.instance.signOut();
      prefs.remove("seenOnboarding"); // Clear onboarding state if necessary

      // Navigate to signinChoice screen after sign-out
      Navigator.pushNamedAndRemoveUntil(
          context, "/signinChoice", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SplashScreen()));
  }
}
