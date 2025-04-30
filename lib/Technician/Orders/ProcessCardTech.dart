import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import 'model/modelTech.dart';

class ProcessOrderCardTech extends StatelessWidget {
  const ProcessOrderCardTech({required this.orders, super.key});

  final OrderModelTech orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFAEAEAE), width: 1.5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          orders.image ??
                              'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${orders.FName} ${orders.LName}",
                          style: GoogleFonts.cantataOne(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orders.ServiceType,
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Description :'.tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orders.Description,
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Location :".tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' ${orders.Location}',
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Offer Price :".tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' ${orders.previousOffer}',
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Status :'.tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' ${orders.Status}',
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20,
                              color: isDark ? Colors.white : Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            orders.Date,
                            style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20,
                              color: isDark ? Colors.white : Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            orders.Time,
                            style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: WhiteButtonOffer(
                          text: "Cancel".tr(),
                          onPressed: () async {
                            await CancelOrder(context, orders);
                          },
                          font: 18,
                        ),
                      ),
                      Expanded(
                        child: GradientButtonOffer(
                          text: "Complete".tr(),
                          onPressed: () async {
                            await _completeOrder(context, orders);
                          },
                          font: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> incrementServiceCount(String technicianId) async {
    try {
      await FirebaseFirestore.instance
          .collection('technician') // Collection: technicians
          .doc(technicianId) // Document: technicianId
          .update({
        'serviceCount': FieldValue.increment(1), // Increment serviceCount by 1
      });
    } catch (e) {
      print("Error incrementing service count: $e");
    }
  }

  Future<void> _completeOrder(
      BuildContext context, OrderModelTech order) async {
    try {
      final docRef = FirebaseFirestore.instance.doc(order.docPath!);
      await docRef.update({'Status': 'Finished'});

      await incrementServiceCount(FirebaseAuth.instance.currentUser!.uid);

      // Show success message
      Fluttertoast.showToast(
        msg: "Order completed successfully!".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle errors
      Fluttertoast.showToast(
        msg: 'Failed to complete order'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> CancelOrder(BuildContext context, OrderModelTech order) async {
    try {
      final docRef = FirebaseFirestore.instance.doc(order.docPath!);
      await docRef.update({'Status': 'Cancelled'});

      // Show success message
      Fluttertoast.showToast(
        msg: "Order Cancelled!".tr(),
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
  }
}
