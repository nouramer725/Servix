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

class FinishedOrderTechPage extends StatelessWidget {
  const FinishedOrderTechPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return  Center(child: Text('No user logged in'.tr()));
    }

    return FutureBuilder<String>(
        future: getTechnicianSubservice(),
        builder: (context, subserviceSnapshot) {
          if (subserviceSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: ApplicationColor,
            ));
          }

          if (subserviceSnapshot.hasError || !subserviceSnapshot.hasData) {
            return Center(child: Text("Error fetching subservice".tr()));
          }

          final technicianSubservice = subserviceSnapshot.data!;

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collectionGroup('user-services')
                .where('Status', whereIn: ['Finished', 'Cancelled'])
                .where('serviceTitle', isEqualTo: technicianSubservice)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: ApplicationColor,
                ));
              }

              if (snapshot.hasError || !snapshot.hasData) {
                print('Error fetching orders: ${snapshot.error}');
                return  Center(child: Text("Error loading orders".tr()));
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return Center(
                    child: Text("No finished orders available".tr()
                        ,style: GoogleFonts.castoro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)));
              }

              return FutureBuilder<List<OrderModelTech>>(
                future: _filterOrdersWithOffers(docs, user.uid),
                builder: (context, orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: ApplicationColor,
                    ));
                  }

                  if (orderSnapshot.hasError || !orderSnapshot.hasData) {
                    return  Center(child: Text("Error loading offers".tr()));
                  }

                  final orders = orderSnapshot.data!;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return PreviousOrderCardTech(orders: order);
                    },
                  );
                },
              );
            },
          );
        });
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
      List<QueryDocumentSnapshot> docs, String uid) async {
    List<OrderModelTech> orders = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Fetch offers for the order
      final offersSnapshot = await doc.reference
          .collection('offers')
          .where('technicianId', isEqualTo: uid)
          .limit(1)
          .get();

      if (offersSnapshot.docs.isNotEmpty) {
        final offerData = offersSnapshot.docs.first.data();
        final offerValue =
            offerData['technicianOffer']?.toString() ?? 'Not Available';

        // Log the price data to check if it's correct
        print(
            "Offer found for order: ${data['serviceTitle']}, price: $offerValue");

        orders.add(OrderModelTech(
          ServiceType: data['serviceTitle'] ?? '',
          Description: data['description'] ?? '',
          Date: data['selectedDate'] ?? '',
          Time: data['selectedTime'] ?? '',
          Location: data['area'] ?? 'No Location',
          image: data['profileImageUrl'] ??
              "https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg",
          FName: data['firstName'] ?? 'Unknown',
          LName: data['lastName'] ?? 'Unknown',
          docPath: doc.reference.path,
          previousOffer: offerValue,
          Status: data['Status'] ?? 'Unknown',
        ));
      }
    }

    return orders;
  }
}
