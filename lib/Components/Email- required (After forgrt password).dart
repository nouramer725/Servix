// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:servix/Components/Buttons.dart';
// import 'package:servix/Settings/Password.dart';
// import '../Theme/Theme_Provider.dart';
// import 'TextField for Contact us.dart';
//
// class EmailRequired extends StatefulWidget {
//   const EmailRequired({super.key});
//
//   @override
//   State<EmailRequired> createState() => _EmailRequiredState();
// }
//
// class _EmailRequiredState extends State<EmailRequired> {
//   final TextEditingController emailController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore Firestore = FirebaseFirestore.instance;
//
//   Future<void> fetchAndSendPassword(String email) async {
//     try {
//       // Query Firestore for the document that has the matching email field
//       var querySnapshot = await Firestore.collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // If the user is found, get the first document
//         var userDoc = querySnapshot.docs.first;
//         String password = userDoc.data()['password'] ?? '';
//
//         if (password.isNotEmpty) {
//           // Send password reset link using Firebase Authentication
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChangePasswordScreen(),
//               ));
//           await _auth.sendPasswordResetEmail(email: email);
//           // showDialog(
//           //   context: context,
//           //   builder: (context) => AlertDialog(
//           //     title: Text('Password Reset Link Sent'),
//           //     content: Text('Please check your email for a password reset link.'),
//           //     actions: <Widget>[
//           //       TextButton(
//           //         onPressed: () => Navigator.of(context).pop(),
//           //         child: Text('OK'),
//           //       ),
//           //     ],
//           //   ),
//           // );
//         } else {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Error'),
//               content: Text('No password found for this email.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             ),
//           );
//         }
//       } else {
//         // If no document is found with the email
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Email Not Found'),
//             content: Text('No account found with this email address.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error: $e');
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('An error occurred while processing your request.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "Find Your Account",
//               style: GoogleFonts.castoro(
//                 color: themeProvider.themeMode == ThemeMode.dark
//                     ? Colors.white
//                     : Colors.black,
//                 fontSize: 28,
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Enter your email address.",
//               style: GoogleFonts.castoro(
//                 color: themeProvider.themeMode == ThemeMode.dark
//                     ? Colors.white54
//                     : Colors.black,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             customTextFieldContact(
//               controller: emailController,
//               labelText: "Email address",
//               keyboardTypee: TextInputType.emailAddress,
//               themeProvider: themeProvider,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Text(
//               "After continue, Please check your email! We will send you a link with your current password",
//               style: GoogleFonts.castoro(
//                 color: themeProvider.themeMode == ThemeMode.dark
//                     ? Colors.white54
//                     : Colors.black,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: GradientButton(
//           onPressed: () {
//             // Call the function to fetch and send password
//             fetchAndSendPassword(emailController.text.trim());
//           },
//           text: "Continue",
//         ),
//       ),
//     );
//   }
// }
