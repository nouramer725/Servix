import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/constents/constent.dart';
import 'Previous Card Tech.dart';
import 'model/modelTech.dart';

class FinishedOrderTechPage extends StatelessWidget {
  const FinishedOrderTechPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in'));
    }

    return FutureBuilder<String>(
        future: getTechnicianSubservice(),
        builder: (context, subserviceSnapshot) {
          if (subserviceSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: ApplicationColor,
            ));
          }

          if (subserviceSnapshot.hasError || !subserviceSnapshot.hasData) {
            return Center(child: Text('Error fetching subservice'));
          }

          final technicianSubservice = subserviceSnapshot.data!;

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collectionGroup('user-services')
                .where('Status',
                    isEqualTo: 'Finished') // Status is 'Finished' now
                .where('serviceTitle', isEqualTo: technicianSubservice)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  color: ApplicationColor,
                ));
              }

              if (snapshot.hasError || !snapshot.hasData) {
                print('Error fetching orders: ${snapshot.error}');
                return const Center(child: Text('Error loading orders'));
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                    child: Text('No finished orders available'));
              }

              return FutureBuilder<List<OrderModelTech>>(
                future: _filterOrdersWithOffers(docs, user.uid),
                builder: (context, orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return  Center(child: CircularProgressIndicator(
                      color: ApplicationColor,
                    ));
                  }

                  if (orderSnapshot.hasError || !orderSnapshot.hasData) {
                    return const Center(child: Text('Error loading offers'));
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
              "assets/images/lang-member/langmem.png",
          FName: data['firstName'] ?? 'Unknown',
          LName: data['lastName'] ?? 'Unknown',
          docPath: doc.reference.path,
          previousOffer: offerValue, // This is where the price is assigned
        ));
      }
    }

    return orders;
  }
}
