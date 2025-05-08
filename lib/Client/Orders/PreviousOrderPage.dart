import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'OrderCardImgPrevious.dart';
import 'model/model.dart';

class PreviousOrderPage extends StatefulWidget {
  const PreviousOrderPage({super.key});

  @override
  State<PreviousOrderPage> createState() => _PreviousOrderPageState();
}

class _PreviousOrderPageState extends State<PreviousOrderPage> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<OrderModel>> _fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('Services Requests')
        .doc(user.uid)
        .collection('user-services')
        .where('Status', whereIn: ['Finished', 'Cancelled']).get();

    final futures = snapshot.docs.map((doc) async {
      final data = doc.data();
      final offerSnapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(user.uid)
          .collection('user-services')
          .doc(doc.id)
          .collection('offers')
          .get();

      if (offerSnapshot.docs.isNotEmpty) {
        final offerData = offerSnapshot.docs.first.data();
        data.addAll(offerData);
      }

      return OrderModel(
        ServiceType: data['serviceTitle']?['en'] ?? 'No Service Type',
        technicianOffer: data['technicianOffer']?.toString() ?? '',
        Description: data['description'] ?? '',
        Location: data['area']?.toString() ?? '',
        apartment: data['apartment']?.toString() ?? '',
        ServiceImage: data['serviceImage']?.toString() ?? '',
        building: data['building']?.toString() ?? '',
        ProfileImage: data['profileImageUrl']?.toString() ?? '',
        Fname: data['firstName']?.toString() ?? '',
        Lname: data['lastName']?.toString() ?? '',
        street: data['street']?.toString() ?? '',
        fileUrls: List<String>.from(data['fileUrls'] ?? []),
        Status: data['Status']?.toString() ?? '',
        Date: data['selectedDate']?.toString() ?? '',
        Time: data['selectedTime']?.toString() ?? '',
        orderId: doc.id,
        technicianImage: data['technicianImage']?.toString() ?? '',
        technicianName: data['technicianName']?.toString() ?? '',
        technicianLocationArea: data['technicianLocationArea'] ?? '',
        technicianLocationStreet: data['technicianLocationStreet'] ?? '',
        technicianPhone: data['technicianPhone'] ?? '',
        technicianSub: data['technicianSubService'] ?? '',
        technicianMain: data['technicianMainService'] ?? '',
        technicianDescription: data['technicianDescription'] ?? '',
        technicianLinkSocialMedia: data['technicianLinkSocialMedia'] ?? '',
        technicianId: data['technicianId'] ?? '',
      );
    }).toList();

    return await Future.wait(futures);
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return RefreshIndicator(
      color: ApplicationColor,
      backgroundColor: Colors.white,
      onRefresh: _refreshOrders,
      child: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: ApplicationColor));
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('An error occurred'.tr()));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return ListView(
              // Needed to enable pull-to-refresh even when empty
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'No Previous orders found.'.tr(),
                      style: GoogleFonts.castoro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCardImgPrevious(orders: orders[index]);
            },
          );
        },
      ),
    );
  }
}
