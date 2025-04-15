import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Technician/Orders/OrderCardTech.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';

class ProcessOrderTechPage extends StatelessWidget {
  const ProcessOrderTechPage({super.key});

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
          return const Center(child: CircularProgressIndicator());
        }

        if (subserviceSnapshot.hasError || !subserviceSnapshot.hasData) {
          return Center(child: Text('Error fetching subservice'));
        }

        final technicianSubservice = subserviceSnapshot.data!;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collectionGroup('user-services')
              .where('Status', isEqualTo: 'In Progress')
              .where('serviceTitle', isEqualTo: technicianSubservice)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              print('Error fetching orders: ${snapshot.error}');
              return const Center(child: Text('Error loading orders'));
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No orders available'));
            }

            final orders = docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return OrderModelTech(
                ServiceType: data['serviceTitle'] ?? '',
                Description: data['description'] ?? '',
                Date: data['selectedDate'] ?? '',
                Time: data['selectedTime'] ?? '',
                Location: data['area'] ?? 'No Location',
                image: data['profileImageUrl'] ?? data['imagePath'],
                FName: data['firstName'] ?? 'Unknown',
                LName: data['lastName'] ?? 'Unknown',
              );
            }).toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCardTech(orders: order);
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
}
