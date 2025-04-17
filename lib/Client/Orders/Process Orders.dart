import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constents/constent.dart';
import 'OrderCard.dart';
import 'OrderCardImg.dart';
import 'model/model.dart';

class ProcessOrderPage extends StatelessWidget {
  const ProcessOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in'));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(user.uid)
          .collection('user-services')
          .where('Status', isEqualTo: 'In Progress')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: ApplicationColor));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Processing orders found.'));
        }

        final orders = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final userUid = user.uid;
          final serviceId = doc.id;

          // Fetch the technician's offer details
          final offerFuture = FirebaseFirestore.instance
              .collection('Services Requests')
              .doc(userUid)
              .collection('user-services')
              .doc(serviceId)
              .collection('offers')
              .get()
              .then((offerSnapshot) {
            if (offerSnapshot.docs.isNotEmpty) {
              final offerData = offerSnapshot.docs.first.data();
              data['technicianImage'] = offerData['technicianImage'];
              data['technicianName'] = offerData['technicianName'];
              data['technicianLocationArea'] = offerData['technicianLocationArea'];
              data['technicianLocationStreet'] = offerData['technicianLocationStreet'];
              data['technicianPhone'] = offerData['technicianPhone'];
              data['technicianSubService'] = offerData['technicianSubService'];
              data['technicianMainService'] = offerData['technicianMainService'];
              data['technicianDescription'] = offerData['technicianDescription'];
              // data['technicianRating'] = offerData['technicianRating'];
              data['technicianProducts'] = offerData['technicianProducts'];
              data['technicianLinkSocialMedia'] = offerData['technicianLinkSocialMedia'];
              data['technicianId'] = offerData['technicianId'];

            }
            return data;
          });

          return offerFuture.then((updatedData) {
            return OrderModel(
              ServiceType: updatedData['serviceTitle'] ?? 'No Service Type',
              Description: updatedData['description'] ?? '',
              Status: updatedData['Status'] ?? '',
              Date: updatedData['selectedDate'] ?? '',
              Time: updatedData['selectedTime'] ?? '',
              orderId: doc.id,
              technicianImage: updatedData['technicianImage'],
              technicianName: updatedData['technicianName'],
              technicianLocationArea: updatedData['technicianLocationArea'] ?? '',
              technicianLocationStreet: updatedData['technicianLocationStreet'] ?? '',
              technicianPhone: updatedData['technicianPhone'] ?? '',
              technicianSub: updatedData['technicianSubService'] ?? '',
              technicianMain: updatedData['technicianMainService'] ?? '',
              technicianDescription: updatedData['technicianDescription'] ?? '',
              // technicianRating: updatedData['technicianRating'] ??  0.0,
              technicianProducts: updatedData['technicianProducts'] ?? [],
              technicianLinkSocialMedia: updatedData['technicianLinkSocialMedia'] ?? '',
              technicianId: updatedData['technicianId'] ?? '',
            );
          });
        }).toList();

        return FutureBuilder(
          future: Future.wait(orders),
          builder: (context, orderSnapshot) {
            if (orderSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: ApplicationColor));
            }

            if (orderSnapshot.hasError) {
               print('Error: ${orderSnapshot.error}');
            }

            final orders = orderSnapshot.data ?? [];

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCardImg(orders: order);
              },
            );
          },
        );
      },
    );
  }
}
