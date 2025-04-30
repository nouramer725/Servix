import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import '../technician View/Profile tech.dart';
import 'model/model.dart';

class OrderCardImg extends StatelessWidget {
  const OrderCardImg({required this.orders, super.key});
  final OrderModel orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFAEAEAE),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description Of Service :'.tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decoration: TextDecoration.underline,
                      decorationColor: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decorationThickness: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Type of service :'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ?Colors.white
                                :Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          orders.ServiceType.tr(),
                          style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Description :'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          orders.Description,
                          style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Status :'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orders.Status.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        orders.Date.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        orders.Time.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GradientButtonOffer(
                          onPressed: () async {
                            await CancelOrder(context, orders);
                          },
                          text: "Cancel Post".tr(),
                          font: 20),
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: context.locale.languageCode == 'ar' ? 5 : null,
                right: context.locale.languageCode == 'en' ? 5 : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TechnicianProfileScreen(
                              technicianName: orders.technicianName,
                              technicianId: orders.technicianId,
                              technicianImage: orders.technicianImage,
                              technicianLocationArea:
                                  orders.technicianLocationArea,
                              technicianLocationStreet:
                                  orders.technicianLocationStreet,
                              technicianPhone: orders.technicianPhone,
                              technicianSub: orders.technicianSub,
                              technicianMain: orders.technicianMain,
                              technicianDescription:
                                  orders.technicianDescription,
                              technicianLinkSocialMedia:
                                  orders.technicianLinkSocialMedia,
                            ),
                          ),
                        );
                      },
                      child: ClipOval(
                        child: Image.network(
                          orders.technicianImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        orders.technicianName,
                        style: GoogleFonts.castoro(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> CancelOrder(BuildContext context, OrderModel order) async {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    bool? confirmCancellation = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Confirm Cancellation".tr(),
            style: GoogleFonts.castoro(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          content: Text("Are you sure you want to cancel this order?".tr(),
              style: GoogleFonts.castoro(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels the action
              },
              child: Text("No".tr(),
                  style: GoogleFonts.castoro(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 25,
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // User confirms the cancellation
              },
              child: Text("Yes".tr(),
                  style: GoogleFonts.castoro(
                      fontSize: 25,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : ApplicationColor)),
            ),
          ],
        );
      },
    );

    // If the user confirmed the cancellation, proceed with the order update
    if (confirmCancellation == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final uid = user!.uid;

        await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(uid)
            .collection('user-services')
            .doc(order.orderId)
            .update({'Status': 'Cancelled'});

        Fluttertoast.showToast(
          msg: "Order cancelled!".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Failed to cancel order".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // If the user cancels, show a cancellation message or handle the action accordingly
      Fluttertoast.showToast(
        msg: "Order cancellation was not confirmed".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
