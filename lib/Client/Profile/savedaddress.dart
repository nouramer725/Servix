import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Profile/edit_address.dart';
import 'package:servix/Client/Profile/google%20map.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';

class SavedAddressesprofile extends StatefulWidget {
  const SavedAddressesprofile({super.key});

  @override
  State<SavedAddressesprofile> createState() => _SavedAddressesprofileState();
}

class _SavedAddressesprofileState extends State<SavedAddressesprofile> {
  List<Map<String, dynamic>> newLocations = [];

  Future<void> fetchUserNewLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('NewLocationDetails')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          newLocations = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        if (kDebugMode) {
          print('No location details found for this user.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching location: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserNewLocation();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          'Saved Address'.tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0,left: 25),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleMapClient(),
                    ));
              },
              child: Text(
                "Create".tr(),
                style: GoogleFonts.cantataOne(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : ApplicationColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: newLocations.isEmpty
          ? Center(
              child: Text(
                'No address found.'.tr(),
                style: GoogleFonts.castoro(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newLocations.length,
                        itemBuilder: (context, index) {
                          final location = newLocations[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${location['area']}, ${location['street']}, ${location['building']} building, apartment no.${location['apartment']}",
                                      style: GoogleFonts.castoro(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF676565),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const EditAddress(),
                                          ));
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                height: 40,
                                indent: 10,
                                endIndent: 10,
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
