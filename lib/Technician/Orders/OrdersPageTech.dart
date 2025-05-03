import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  Set<String> notifiedOrderIds = {};

  @override
  void initState() {
    super.initState();
    _loadNotifiedOrderIds();
  }

  Future<void> _loadNotifiedOrderIds() async {
    final prefs = await SharedPreferences.getInstance();
    notifiedOrderIds = prefs.getStringList('notifiedOrderIds')?.toSet() ?? {};
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
          return Center(child: Text('Error fetching subservice'.tr()));
        }

        final technicianSubservice = subserviceSnapshot.data!;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collectionGroup('user-services')
              .where('Status', isEqualTo: 'Pending')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: ApplicationColor));
            }

            if (snapshot.hasError || !snapshot.hasData) {
              print('Error fetching orders: ${snapshot.error}');
              return Center(child: Text('Error loading orders'.tr()));
            }

            final docs = snapshot.data!.docs;

            // 🔎 Filter orders where service title (localized) == technician subservice
            final filteredOrders = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final serviceTitleMap = data['serviceTitle'];

              if (serviceTitleMap is Map<String, dynamic>) {
                final localizedMap = Map<String, String>.from(serviceTitleMap);
                final normalizedSubservice =
                    technicianSubservice.toLowerCase().trim();

                // Check against all language values
                return localizedMap.values.any(
                  (title) => title.toLowerCase().trim() == normalizedSubservice,
                );
              }
              return false;
            }).toList();

            if (filteredOrders.isEmpty) {
              return Center(
                child: Text('No orders available'.tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)),
              );
            }

            final orders = filteredOrders.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final serviceTitleMap = data['serviceTitle'];
              Map<String, String> serviceTitleMapChecked = {};
              if (serviceTitleMap is Map<String, dynamic>) {
                serviceTitleMapChecked =
                    Map<String, String>.from(serviceTitleMap);
              }

              final localizedServiceTitle =
                  _getServiceTitle(serviceTitleMapChecked);

              return OrderModelTech(
                ServiceType: localizedServiceTitle,
                Description: data['description'] ?? '',
                Date: data['selectedDate'] ?? '',
                Time: data['selectedTime'] ?? '',
                Location: data['area'] ?? 'No Location',
                apartment: data['apartment'] ?? 'No Apartment',
                building: data['building'] ?? 'No building',
                street: data['street'] ?? 'No street',
                fileUrls: List<String>.from(data['fileUrls'] ?? []),
                ServiceImage: data['serviceImage']?.toString() ?? '',
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

  String _getServiceTitle(Map<String, String> serviceTitleMap) {
    final locale = context.locale.languageCode;
    return serviceTitleMap[locale] ?? serviceTitleMap['en'] ?? '';
  }
}
