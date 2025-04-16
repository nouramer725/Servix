import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Technician/Orders/OrderCardTech.dart';
import 'package:servix/Technician/Orders/PreviousOrderPageTech.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/OrderGradientButton.dart';
import '../../Components/OrderWhiteButton.dart';
import 'Process OrdersTech.dart';

class OrdersPageTech extends StatefulWidget {
  const OrdersPageTech({super.key});

  @override
  _OrdersPageTechState createState() => _OrdersPageTechState();
}

class _OrdersPageTechState extends State<OrdersPageTech> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _selectedIndex == 0
                      ? OrderGradientButton(
                          onPressed: () {},
                          text: 'Current',
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          text: 'Current',
                        ),
                ),
                Expanded(
                  child: _selectedIndex == 1
                      ? OrderGradientButton(
                          onPressed: () {},
                          text: 'Processing',
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          text: 'Processing',
                        ),
                ),
                Expanded(
                  child: _selectedIndex == 2
                      ? OrderGradientButton(
                          onPressed: () {},
                          text: 'Finished',
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          text: 'Finished',
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedIndex == 0
                  ? _currentOrdersTech()
                  : _selectedIndex == 1
                      ? const ProcessOrderTechPage()
                      : const FinishedOrderTechPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentOrdersTech() {
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
          return Center(child: Text('Error fetching subservice'));
        }

        final technicianSubservice = subserviceSnapshot.data!;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collectionGroup('user-services')
              .where('Status', isEqualTo: 'Pending')
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
                image: data['profileImageUrl'] ??
                    "assets/images/lang-member/langmem.png",
                FName: data['firstName'] ?? 'Unknown',
                LName: data['lastName'] ?? 'Unknown',
                docPath: doc.reference.path,
                previousOffer: data['technicianOffer'],
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
