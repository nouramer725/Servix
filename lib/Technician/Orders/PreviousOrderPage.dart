import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Technician/Orders/OrderCard.dart';
import '../../constents/constent.dart';
import 'model/model.dart';

class PreviousOrderTechPage extends StatelessWidget {
  const PreviousOrderTechPage({super.key});

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
          .where('Status', isEqualTo: 'Finished')
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
          return const Center(child: Text('No Previous orders found.'));
        }

        final orders = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return OrderModelTech(
            ServiceType: data['serviceTitle'] ?? 'No Service Type',
            Description: data['description'] ?? '',
            Date: data['selectedDate'] ?? '',
            Time: data['selectedTime'] ?? '',
            image: data['personalFileUrl'] ?? data['imagePath'],
            Name: data['providerName'] ?? 'Unknown',
            Location: data['location'] ?? 'Unknown',
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
  }
}
