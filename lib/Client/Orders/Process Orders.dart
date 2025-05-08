import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'OrderCardImg.dart';
import 'model/model.dart';

class ProcessOrderPage extends StatefulWidget {
  const ProcessOrderPage({super.key});

  @override
  State<ProcessOrderPage> createState() => _ProcessOrderPageState();
}

class _ProcessOrderPageState extends State<ProcessOrderPage> {
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
        .where('Status', isEqualTo: 'In Progress')
        .get();

    if (snapshot.docs.isEmpty) return [];

    final ordersFutures = snapshot.docs.map((doc) async {
      final data = doc.data();
      final userUid = user.uid;
      final serviceId = doc.id;

      final offerSnapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(userUid)
          .collection('user-services')
          .doc(serviceId)
          .collection('offers')
          .get();

      if (offerSnapshot.docs.isNotEmpty) {
        final offerData = offerSnapshot.docs.first.data();
        data['technicianImage'] = offerData['technicianImage'];
        data['technicianName'] = offerData['technicianName'];
        data['technicianLocationArea'] = offerData['technicianLocationArea'];
        data['technicianLocationStreet'] =
            offerData['technicianLocationStreet'];
        data['technicianPhone'] = offerData['technicianPhone'];
        data['technicianSubService'] = offerData['technicianSubService'];
        data['technicianMainService'] = offerData['technicianMainService'];
        data['technicianDescription'] = offerData['technicianDescription'];
        data['technicianLinkSocialMedia'] =
            offerData['technicianLinkSocialMedia'];
        data['technicianId'] = offerData['technicianId'];
        data['technicianOffer'] = offerData['technicianOffer'];
      }

      return OrderModel(
        ServiceType: data['serviceTitle']?['en'] ?? 'No Service Type',
        technicianOffer: data['technicianOffer']?.toString() ?? '',
        Description: data['description'] ?? '',
        Status: data['Status'] ?? '',
        Date: data['selectedDate'] ?? '',
        Time: data['selectedTime'] ?? '',
        Location: data['area']?.toString() ?? '',
        ServiceImage: data['serviceImage']?.toString() ?? '',
        apartment: data['apartment']?.toString() ?? '',
        ProfileImage: data['profileImageUrl']?.toString() ?? '',
        Fname: data['firstName']?.toString() ?? '',
        Lname: data['lastName']?.toString() ?? '',
        building: data['building']?.toString() ?? '',
        street: data['street']?.toString() ?? '',
        fileUrls: List<String>.from(data['fileUrls'] ?? []),
        orderId: doc.id,
        technicianImage: data['technicianImage'],
        technicianName: data['technicianName'],
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

    return await Future.wait(ordersFutures);
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('No user logged in'.tr()));
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: ApplicationColor,
      backgroundColor: Colors.white,
      child: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: ApplicationColor));
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Something went wrong'.tr()),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'No Processing orders found.'.tr(),
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
              return OrderCardImg(orders: orders[index]);
            },
          );
        },
      ),
    );
  }
}
