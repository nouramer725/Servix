import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';
import 'Previous Card Tech.dart';
import 'model/modelTech.dart';

class FinishedOrderTechPage extends StatefulWidget {
  const FinishedOrderTechPage({super.key});

  @override
  State<FinishedOrderTechPage> createState() => _FinishedOrderTechPageState();
}

class _FinishedOrderTechPageState extends State<FinishedOrderTechPage> {
  late Future<String> technicianSubserviceFuture;
  late Future<QuerySnapshot> ordersSnapshotFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    technicianSubserviceFuture = getTechnicianSubservice();
    ordersSnapshotFuture = FirebaseFirestore.instance
        .collectionGroup('user-services')
        .where('Status', whereIn: ['Finished', 'Cancelled']).get();
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadData(); // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('No user logged in'.tr()));
    }

    return FutureBuilder<String>(
      future: technicianSubserviceFuture,
      builder: (context, subserviceSnapshot) {
        if (subserviceSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: ApplicationColor));
        }

        if (subserviceSnapshot.hasError || !subserviceSnapshot.hasData) {
          return Center(child: Text("Error fetching subservice".tr()));
        }

        return FutureBuilder<QuerySnapshot>(
          future: ordersSnapshotFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: ApplicationColor));
            }

            if (snapshot.hasError || !snapshot.hasData) {
              print('Error fetching orders: ${snapshot.error}');
              return Center(child: Text("Error loading orders".tr()));
            }

            final docs = snapshot.data!.docs;

            return FutureBuilder<List<OrderModelTech>>(
              future: _filterOrdersWithOffers(docs, user.uid, context),
              builder: (context, orderSnapshot) {
                if (orderSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: ApplicationColor));
                }

                if (orderSnapshot.hasError || !orderSnapshot.hasData) {
                  return Center(child: Text("Error loading offers".tr()));
                }

                final orders = orderSnapshot.data!;

                if (orders.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "No finished orders available".tr(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.castoro(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  color: ApplicationColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return PreviousOrderCardTech(orders: order);
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> getTechnicianSubservice() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();
    return doc['sub_service'];
  }

  Future<List<OrderModelTech>> _filterOrdersWithOffers(
      List<QueryDocumentSnapshot> docs,
      String uid,
      BuildContext context) async {
    List<OrderModelTech> orders = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Log data to check if it contains offers
      print("Processing Order: ${data['serviceTitle']}");

      // Fetch offers for this order where the technicianId matches the provided uid
      final offersSnapshot = await doc.reference
          .collection('offers')
          .where('technicianId', isEqualTo: uid)
          .limit(1)
          .get();

      // Log offers snapshot data
      if (offersSnapshot.docs.isEmpty) {
        print("No offers for this order.");
      } else {
        print("Found offers for this order.");
      }

      // If offers are found, process them
      if (offersSnapshot.docs.isNotEmpty) {
        final offerData = offersSnapshot.docs.first.data();
        final offerValue =
            offerData['technicianOffer']?.toString() ?? 'Not Available';

        final serviceTitleMap = data['serviceTitle'];
        Map<String, String> serviceTitleMapChecked = {};
        if (serviceTitleMap is Map<String, dynamic>) {
          serviceTitleMapChecked = Map<String, String>.from(serviceTitleMap);
        }

        final localizedServiceTitle =
            getServiceTitle(serviceTitleMapChecked, context);

        // Create an OrderModelTech object with the filtered data
        orders.add(OrderModelTech(
          ServiceType: localizedServiceTitle,
          Description: data['description'] ?? 'No Description',
          Date: data['selectedDate'] ?? 'No Date',
          Time: data['selectedTime'] ?? 'No Time',
          Location: data['area'] ?? 'No Location',
          apartment: data['apartment'] ?? 'No Apartment',
          building: data['building'] ?? 'No building',
          street: data['street'] ?? 'No street',
          fileUrls: List<String>.from(data['fileUrls'] ?? []),
          ServiceImage: data['serviceImage']?.toString() ?? '',

          image: data['profileImageUrl'] ??
              "https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg",
          FName: data['firstName'] ?? 'Unknown',
          LName: data['lastName'] ?? 'Unknown',
          docPath: doc.reference.path,
          Status: data['Status'] ?? 'Unknown',
          previousOffer: offerValue, // assign offer value here
        ));
      }
    }

    return orders;
  }

  String getServiceTitle(
      Map<String, String> serviceTitleMap, BuildContext context) {
    final locale = context.locale.languageCode;
    return serviceTitleMap[locale] ?? serviceTitleMap['en'] ?? '';
  }
}
