import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';
import 'package:servix/constents/constent.dart';
import 'ProcessCardTech.dart';

class ProcessOrderTechPage extends StatelessWidget {
  const ProcessOrderTechPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('No user logged in'.tr()));
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
          return Center(child: Text('Error fetching subservice'.tr()));
        }

        final technicianSubservice = subserviceSnapshot.data!;
        final uid = FirebaseAuth.instance.currentUser!.uid;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collectionGroup('user-services')
              .where('Status', isEqualTo: 'In Progress')
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
              return Center(child: Text('Error loading orders'.tr()));
            }

            final docs = snapshot.data!.docs;
            // Filter by localized service title
            final filteredDocs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final serviceTitle = data['serviceTitle'];
              if (serviceTitle is Map<String, dynamic>) {
                return serviceTitle.values.any(
                  (val) =>
                      val.toString().toLowerCase().trim() ==
                      technicianSubservice.toLowerCase().trim(),
                );
              }
              return false;
            }).toList();

            return FutureBuilder<List<OrderModelTech>>(
              future: _filterOrdersWithOffers(filteredDocs, uid, context),
              builder: (context, filteredSnapshot) {
                if (filteredSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: ApplicationColor));
                }

                if (filteredSnapshot.hasError || !filteredSnapshot.hasData) {
                  return Center(
                      child: Text("Error loading filtered orders".tr()));
                }

                final orders = filteredSnapshot.data!;
                if (orders.isEmpty) {
                  return Center(child: Text("No Offers Made".tr()));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ProcessOrderCardTech(orders: order);
                  },
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
