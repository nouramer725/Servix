import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Profile/edit_address.dart';
import 'package:servix/Client/Profile/google%20map.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/Buttons.dart';
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
          newLocations = querySnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // 👈 Add document ID here
            return data;
          }).toList();
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
          'Saved Addresses'.tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
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
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? const Color(0xFF333739)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.black12,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${"Saved Address".tr()} ${index + 1}".tr(),
                                  style: GoogleFonts.castoro(
                                    fontSize: 23,
                                    color: themeProvider.themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                ),
                                const Divider(
                                  thickness: 1,
                                  height: 25,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: ApplicationColor,
                                      size: 25,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${location['area']}",
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : const Color(0xFF333739),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${location['street']}, ${location['building']}, apartment no.${location['apartment']}, floor no.${location['floor']}",
                                  style: GoogleFonts.castoro(
                                    fontSize: 20,
                                    color: themeProvider.themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : const Color(0xFF333739),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                ),
                                const SizedBox(
                                  height: 13,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor:
                                                themeProvider.themeMode ==
                                                        ThemeMode.dark
                                                    ? const Color(0xFF333739)
                                                    : Colors.white,
                                            title: Row(
                                              children: [
                                                Icon(Icons.delete_outline,
                                                    color: themeProvider
                                                                .themeMode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black),
                                                const SizedBox(width: 10),
                                                Text('Delete Address'.tr(),
                                                    style: GoogleFonts.castoro(
                                                        color: themeProvider
                                                                    .themeMode ==
                                                                ThemeMode.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 25)),
                                              ],
                                            ),
                                            content: Text(
                                                'Are you sure you want to delete this saved address?'
                                                    .tr(),
                                                style: GoogleFonts.castoro(
                                                    color: themeProvider
                                                                .themeMode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 20)),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text('Cancel'.tr(),
                                                    style: GoogleFonts.castoro(
                                                        fontSize: 20,
                                                        color: themeProvider
                                                                    .themeMode ==
                                                                ThemeMode.dark
                                                            ? Colors.white
                                                            : Colors.black)),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    deleteUserAddress(
                                                  location['id'],
                                                ),
                                                child: Text(
                                                  'Delete'.tr(),
                                                  style: GoogleFonts.castoro(
                                                    color: themeProvider
                                                                .themeMode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : ApplicationColor,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Delete".tr(),
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          color: ApplicationColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAddress(
                                                area: location['area'],
                                                street: location['street'],
                                                building: location['building'],
                                                apartment:
                                                    location['apartment'],
                                                floor: location['floor'],
                                                directions:
                                                    location['directions'],
                                                label: location['label'],
                                                latitude: location['latitude'],
                                                longitude:
                                                    location['longitude'],
                                                id: location['id'],
                                              ),
                                            ));
                                      },
                                      child: Text(
                                        "Edit".tr(),
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          color: ApplicationColor3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 10),
        child: GradientButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoogleMapClient(),
                  ));
            },
            text: "Add New Address".tr()),
      ),
    );
  }

  Future<void> deleteUserAddress(String docId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('NewLocationDetails')
          .doc(docId)
          .delete();

      Fluttertoast.showToast(
        msg: 'Address deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColor,
        textColor: Colors.white,
      );
      Navigator.pop(context);
      Navigator.pop(context);


      // Refresh list after deletion
      fetchUserNewLocation();
    } catch (e) {
      print('Error deleting address: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
