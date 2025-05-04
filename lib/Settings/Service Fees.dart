import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:servix/constents/constent.dart';
import '../Theme/Theme_Provider.dart';

class ServiceFees extends StatefulWidget {
  const ServiceFees({super.key});

  @override
  State<ServiceFees> createState() => _ServiceFeesState();
}

class _ServiceFeesState extends State<ServiceFees> {
  bool isLoading = true;
  Map<String, List<TechnicianOffer>> groupedOffers = {};
  Map<String, double> monthlyTotalFees =
      {}; // To store total fees for each month

  Future<void> fetchFinishedServices() async {
    try {
      final String technicianId = FirebaseAuth.instance.currentUser!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      print('Fetching finished services for technician: $technicianId');

      final QuerySnapshot serviceRequestsSnapshot = await firestore
          .collectionGroup('user-services')
          .where('Status', isEqualTo: 'Finished')
          .get();

      Map<String, List<TechnicianOffer>> tempGroupedOffers = {};
      Map<String, double> tempMonthlyTotalFees = {};

      if (serviceRequestsSnapshot.docs.isNotEmpty) {
        for (final serviceDoc in serviceRequestsSnapshot.docs) {
          final serviceData = serviceDoc.data() as Map<String, dynamic>;
          print('Service Data for ${serviceDoc.id}: $serviceData');

          // Check offer exists for this technician
          final offerSnapshot = await firestore
              .doc(serviceDoc.reference.path)
              .collection('offers')
              .doc(technicianId)
              .get();

          if (!offerSnapshot.exists) {
            print('No offer for this technician in ${serviceDoc.id}');
            continue;
          }

          final offerData = offerSnapshot.data()!;
          final dynamic rawFees = offerData['technicianFees'];
          double parsedFees = 0.0;

          if (rawFees is int) {
            parsedFees = rawFees.toDouble();
          } else if (rawFees is double) {
            parsedFees = rawFees;
          } else if (rawFees is String) {
            parsedFees = double.tryParse(rawFees) ?? 0.0;
          }

          final dateStr = serviceData['selectedDate'] ?? '';
          final time = serviceData['selectedTime'] ?? '';
          final fname = serviceData['firstName'] ?? '';
          final lname = serviceData['lastName'] ?? '';

          if (dateStr.isEmpty) {
            print("Skipping service ${serviceDoc.id} due to missing date");
            continue;
          }

          DateTime parsedDate;
          try {
            parsedDate = DateFormat('dd-MM-yyyy').parse(dateStr);
          } catch (e) {
            print("Skipping invalid date format in ${serviceDoc.id}: $dateStr");
            continue;
          }

          final String monthKey = DateFormat.yMMMM().format(parsedDate);

          tempGroupedOffers.putIfAbsent(monthKey, () => []);
          tempMonthlyTotalFees[monthKey] ??= 0.0;

          tempGroupedOffers[monthKey]!.add(TechnicianOffer(
            clientId: serviceData['userId'] ?? '',
            serviceId: serviceDoc.id,
            firstName: fname,
            lastName: lname,
            time: time,
            date: dateStr,
            serviceFees: parsedFees,
          ));

          tempMonthlyTotalFees[monthKey] =
              (tempMonthlyTotalFees[monthKey]! + parsedFees);
        }

        setState(() {
          groupedOffers = tempGroupedOffers;
          monthlyTotalFees = tempMonthlyTotalFees;
          print("Grouped Offers: $groupedOffers");
          print("Monthly Totals: $monthlyTotalFees");
        });
      } else {
        print('No finished services found.');
      }
    } catch (e) {
      print('Error fetching finished services: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFinishedServices();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
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
            children: [
              Text(
                'Note: Service fees are calculated based on the services you made and finished.',
                style: GoogleFonts.castoro(
                  fontSize: 17,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                'Reminder: You are required to pay the total service fees to the application at the end of each month.',
                style: GoogleFonts.castoro(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white24
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
              groupedOffers.isEmpty
                  ? Center(
                      child: LinearProgressIndicator(
                      color: ApplicationColor,
                    ))
                  : Column(
                      children: groupedOffers.entries.map((entry) {
                        final String month = entry.key;
                        final List<TechnicianOffer> offers = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Month: $month',
                                    style: GoogleFonts.castoro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Total Fees: ${monthlyTotalFees[month]?.toStringAsFixed(2)} EGP',
                                    style: GoogleFonts.castoro(
                                      fontSize: 18,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ...offers.map((offer) => Card(
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.grey[900]
                                          : Colors.grey[200],
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: ListTile(
                                    title: Text(
                                      'Service from ${offer.firstName} ${offer.lastName}',
                                      style: GoogleFonts.castoro(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Date: ${offer.date}\nTime: ${offer.time}\nFees: ${offer.serviceFees} EGP',
                                      style: GoogleFonts.castoro(
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white70
                                            : Colors.black38,
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class TechnicianOffer {
  final String clientId;
  final String serviceId;
  final String firstName;
  final String lastName;
  final String time;
  final String date;
  final dynamic serviceFees;

  TechnicianOffer({
    required this.clientId,
    required this.serviceId,
    required this.firstName,
    required this.lastName,
    required this.time,
    required this.date,
    required this.serviceFees,
  });
}
