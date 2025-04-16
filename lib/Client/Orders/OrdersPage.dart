import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Client/Orders/Process%20Orders.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/OrderGradientButton.dart';
import '../../Components/OrderWhiteButton.dart';
import 'OrderCard.dart';
import 'OrderCardImg.dart';
import 'PreviousOrderPage.dart';
import 'model/model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
                      ? const ProcessOrderPage()
                      : const PreviousOrderPage(),
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

          return OrderModel(
            ServiceType: data['serviceTitle'] ?? 'No Service Type',
            Description: data['description'] ?? '',
            Status: data['Status'] ?? '',
            Date: data['selectedDate'] ?? '',
            Time: data['selectedTime'] ?? '',
            technicianName: data['technicianName'] ?? '',
            technicianImage: data['technicianImage'] ?? '',
            technicianLocationArea: data['technicianLocationArea'] ?? '',
            technicianLocationStreet: data['technicianLocationStreet'] ?? '',
            technicianPhone: data['technicianPhone'] ?? '',
            technicianSub: data['technicianSub'] ?? '',
            technicianMain: data['technicianMain'] ?? '',
            orderId: doc.id,
          );
        }).toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            if (order.technicianImage != null && order.technicianName != null) {
              return OrderCardImg(orders: order);
            } else {
              return OrderCard(orders: order);
            }
          },
        );
      },
    );
  }
}
