import 'package:easy_localization/easy_localization.dart';
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
  Map<String, double> monthlyTotalFees = {};

  Future<void> fetchFinishedServices() async {
    try {
      final String technicianId = FirebaseAuth.instance.currentUser!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot serviceRequestsSnapshot = await firestore
          .collectionGroup('user-services')
          .where('Status', isEqualTo: 'Finished')
          .get();

      Map<String, List<TechnicianOffer>> tempGroupedOffers = {};
      Map<String, double> tempMonthlyTotalFees = {};

      if (serviceRequestsSnapshot.docs.isNotEmpty) {
        for (final serviceDoc in serviceRequestsSnapshot.docs) {
          final serviceData = serviceDoc.data() as Map<String, dynamic>;

          final offerSnapshot = await firestore
              .doc(serviceDoc.reference.path)
              .collection('offers')
              .doc(technicianId)
              .get();

          if (!offerSnapshot.exists) continue;

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

          if (dateStr.isEmpty) continue;

          DateTime parsedDate;
          try {
            parsedDate = DateFormat('dd-MM-yyyy').parse(dateStr);
          } catch (e) {
            continue;
          }

          final String monthKey =
              DateFormat.yMMMM(context.locale.languageCode).format(parsedDate);

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
        });
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
          'Service Fees'.tr(),
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
                'Note: Service fees are calculated based on the services you made and finished.'
                    .tr(),
                style: GoogleFonts.castoro(
                  fontSize: 17,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                'Reminder: You are required to pay the total service fees to the application at the end of each month.'
                    .tr(),
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
                'Services:'.tr(),
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
                      child: LinearProgressIndicator(color: ApplicationColor))
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
                                    '${'Month:'.tr()} $month',
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
                                    '${'Total Fees:'.tr()} ${monthlyTotalFees[month]?.toStringAsFixed(2).tr()} ${'EGP'.tr()}',
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
                            ...offers.map((offer) {
                              // Parse the date to display localized format
                              DateTime dateObj;
                              try {
                                dateObj =
                                    DateFormat('dd-MM-yyyy').parse(offer.date);
                              } catch (e) {
                                dateObj = DateTime.now();
                              }
                              final localizedDate =
                                  DateFormat.yMMMd(context.locale.languageCode)
                                      .format(dateObj);
                              return Card(
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.grey[900]
                                    : Colors.grey[200],
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: ListTile(
                                  title: Text(
                                    '${'Service from'.tr()} ${offer.firstName} ${offer.lastName}',
                                    style: GoogleFonts.castoro(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${'Date:'.tr()} $localizedDate',
                                        style: GoogleFonts.castoro(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black38,
                                        ),
                                      ),
                                      Text(
                                        '${'Time:'.tr()} ${offer.time}',
                                        style: GoogleFonts.castoro(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black38,
                                        ),
                                      ),
                                      Text(
                                        '${'Fees:'.tr()} ${offer.serviceFees} ${'EGP'.tr()}',
                                        style: GoogleFonts.castoro(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white70
                                              : Colors.black38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
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
