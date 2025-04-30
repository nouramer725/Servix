import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Orders/Process%20Orders.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/OrderGradientButton.dart';
import '../../Components/OrderWhiteButton.dart';
import '../../Theme/Theme_Provider.dart';
import 'OrderCard.dart';
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
                          text: 'Current'.tr(),
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          text: 'Current'.tr(),
                        ),
                ),
                Expanded(
                  child: _selectedIndex == 1
                      ? OrderGradientButton(
                          onPressed: () {},
                          text: 'Processing'.tr(),
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          text: 'Processing'.tr(),
                        ),
                ),
                Expanded(
                  child: _selectedIndex == 2
                      ? OrderGradientButton(
                          onPressed: () {},
                          text: 'Finished'.tr(),
                        )
                      : OrderWhiteButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          text: 'Finished'.tr(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('No user logged in'.tr()));
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
            child: CircularProgressIndicator(color: ApplicationColor),
          );
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('An error occurred'.tr()));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No current orders found.'.tr(),
              style: GoogleFonts.castoro(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        }

        final orders = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return OrderModel(
            ServiceType:
                data['serviceTitle']?.toString() ?? 'No Service Type'.tr(),
            Description: data['description']?.toString() ?? '',
            Status: data['Status']?.toString() ?? '',
            Date: data['selectedDate']?.toString() ?? '',
            Time: data['selectedTime']?.toString() ?? '',
            technicianName: data['technicianName']?.toString() ?? '',
            technicianImage: data['technicianImage']?.toString() ?? '',
            technicianLocationArea:
                data['technicianLocationArea']?.toString() ?? '',
            technicianLocationStreet:
                data['technicianLocationStreet']?.toString() ?? '',
            technicianPhone: data['technicianPhone']?.toString() ?? '',
            technicianSub: data['technicianSubService']?.toString() ?? '',
            technicianMain: data['technicianMainService']?.toString() ?? '',
            technicianDescription:
                data['technicianDescription']?.toString() ?? '',
            technicianLinkSocialMedia:
                data['technicianLinkSocialMedia']?.toString() ?? '',
            technicianId: data['technicianId']?.toString() ?? '',
            orderId: doc.id,
          );
        }).toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(orders: order);
          },
        );
      },
    );
  }
}
