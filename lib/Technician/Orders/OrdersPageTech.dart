import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servix/Technician/NotificationTech/notification_service_technician.dart';
import 'package:servix/Technician/Orders/OrderCardTech.dart';
import 'package:servix/Technician/Orders/PreviousOrderPageTech.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';
import 'package:servix/constents/constent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/OrderGradientButton.dart';
import '../../Components/OrderWhiteButton.dart';
import '../../Theme/Theme_Provider.dart';
import 'Process OrdersTech.dart';

class OrdersPageTech extends StatefulWidget {
  const OrdersPageTech({super.key});

  @override
  _OrdersPageTechState createState() => _OrdersPageTechState();
}

class _OrdersPageTechState extends State<OrdersPageTech> {
  int _selectedIndex = 0;

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  Set<String> _notifiedOrderIds = {};

  @override
  void initState() {
    super.initState();
    _loadNotifiedOrderIds();
  }

  Future<void> _loadNotifiedOrderIds() async {
    final prefs = await SharedPreferences.getInstance();
    _notifiedOrderIds = prefs.getStringList('notifiedOrderIds')?.toSet() ?? {};
  }

  Future<void> _saveNotifiedOrderIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifiedOrderIds', _notifiedOrderIds.toList());
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<String>(
      future: getTechnicianSubservice(),
      builder: (context, subserviceSnapshot) {
        if (subserviceSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: ApplicationColor));
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
                  child: CircularProgressIndicator(color: ApplicationColor));
            }

            if (snapshot.hasError || !snapshot.hasData) {
              print('Error fetching orders: ${snapshot.error}');
              return const Center(child: Text('Error loading orders'));
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                  child: Text('No orders available',
                      style: GoogleFonts.castoro(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black)));
            }

            final orders = docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              // if (!_notifiedOrderIds.contains(doc.id)) {
              //   final NotificationServiceTechniciann =
              //       NotificationServiceTechnician(
              //           flutterLocalNotificationsPlugin);
              //
              //   NotificationServiceTechniciann.showAndSaveNotificationTech(
              //     title: 'New service',
              //     preview:
              //         'A new order is waiting for your service type. Do not miss the chance to take a look!',
              //   );
              //
              //   _notifiedOrderIds.add(doc.id);
              //   _saveNotifiedOrderIds(); // Save the updated list persistently
              // }

              return OrderModelTech(
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
                previousOffer: data['technicianOffer'],
                Status: data['Status'] ?? 'Pending',
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
