import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import 'DetailsScreen/Details_Pending.dart';
import 'model/model.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({required this.orders, super.key});

  final OrderModel orders;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final firestore = FirebaseFirestore.instance;

    // First path
    final firstDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformation")
        .doc("profile")
        .get();

    if (firstDoc.exists && firstDoc.data()?['personalImageUrl'] != null) {
      setState(() {
        profileImageUrl = firstDoc.data()?['personalImageUrl'];
      });
      return;
    }

    // Second path
    final secondDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformationProvider")
        .doc("profile")
        .get();

    if (secondDoc.exists && secondDoc.data()?['personalImageUrl'] != null) {
      setState(() {
        profileImageUrl = secondDoc.data()?['personalImageUrl'];
      });
      return;
    }

    // Third path
    final thirdSec = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("uploads")
        .limit(1)
        .get();

    if (thirdSec.docs.isNotEmpty) {
      final docData = thirdSec.docs.first.data();
      if (docData['personalFileUrl'] != null) {
        setState(() {
          profileImageUrl = docData['personalFileUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPending(orders: widget.orders)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFAEAEAE),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              profileImageUrl ?? widget.orders.ProfileImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${widget.orders.Fname} ${widget.orders.Lname}",
                            style: GoogleFonts.cantataOne(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPending(orders: widget.orders),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Color(0xFFAEAEAE),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${'Service Type:'.tr()} ${widget.orders.ServiceType.tr()}",
                      style: GoogleFonts.castoro(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${'Status :'.tr()} ${widget.orders.Status.tr()}",
                      style: GoogleFonts.castoro(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 16,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.orders.Date,
                            style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Icon(Icons.access_time,
                            size: 16,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.orders.Time,
                            style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
