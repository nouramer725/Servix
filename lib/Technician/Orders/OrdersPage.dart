import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Technician/Orders/OrderCard.dart';
import 'package:servix/Technician/Orders/PreviousOrderPage.dart';
import 'package:servix/Technician/Orders/Process%20Orders.dart';
import 'package:servix/Technician/Orders/model/model.dart';
import '../../Components/OrderGradientButton.dart';
import '../../Components/OrderWhiteButton.dart';
import '../../constents/constent.dart';

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
                  ? _currentOrders()
                  : _selectedIndex == 1
                      ? const ProcessOrderTechPage()
                      : const PreviousOrderTechPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentOrders() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in'));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(user.uid)
          .collection('user-services')
          .where('Status', whereIn: ['Pending']).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: ApplicationColor));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No current orders found.'));
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
