import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For accessing the current user
import '../Theme/Theme_Provider.dart';

class Servicefees extends StatefulWidget {
  const Servicefees({super.key});

  @override
  State<Servicefees> createState() => _ServicefeesState();
}

class _ServicefeesState extends State<Servicefees> {
  double? serviceFees;
  bool isLoading = true; // To manage the loading state

  // Fetch service fees from Firestore
// Fetch service fees from Firestore
  Future<void> fetchServiceFees() async {
    try {
      // Get current user's technician ID (assuming it's stored in Firestore or via authentication)
      String technicianId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the technician document from Firestore
      DocumentSnapshot technicianSnapshot = await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .get();

      if (technicianSnapshot.exists) {
        final data = technicianSnapshot.data() as Map<String, dynamic>;

        // Get the service fees from the technician document and ensure it's a double
        setState(() {
          serviceFees = (data['serviceFees'] is int
              ? (data['serviceFees'] as int).toDouble()
              : data['serviceFees'] ?? 0.0) as double?;

          isLoading = false; // Data has been loaded, stop loading indicator
        });
      } else {
        setState(() {
          serviceFees = 0.0; // Default value in case data doesn't exist
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        serviceFees = 0.0; // Default value in case of error
        isLoading = false;
      });
      print("Error fetching service fees: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServiceFees(); // Fetch service fees when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white,
        title: Text(
          'Service Fees',
          style: GoogleFonts.castoro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Note: Service fees are calculated based on the service you made and finished it',
                style: GoogleFonts.castoro(
                  fontSize: 16,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Service Fee:',
                    style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    serviceFees?.toStringAsFixed(2) ?? "0.00",
                    style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Text(
                    ' EGP',
                    style: GoogleFonts.castoro(
                      fontSize: 20,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black12,
                thickness: 2,
              ),
              Text(
                'Services:',
                style: GoogleFonts.castoro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  decoration: TextDecoration.underline,
                  decorationColor: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
