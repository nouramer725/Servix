import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/Buttons.dart';
import '../../../../Theme/Theme_Provider.dart';
import '../../../../constents/constent.dart';
import '../../../Home/HomeLayoutClient.dart';
import 'google maps new address.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  String? area;
  String? street;
  String? building;
  String? apartment;

  String? newarea;
  String? newstreet;
  String? newbuilding;
  String? newapartment;
  List<Map<String, dynamic>> newLocations = [];

  int? selectedIndex=-1; // Track the selected index

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchUserNewLocation();
  }

  Future<void> fetchUserLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('locationDetails')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        final lat = data['latitude'];
        final lng = data['longitude'];
        area = data['area'];
        street = data['street'];
        building = data['building'];
        apartment = data['apartment'];

        if (lat != null && lng != null) {
          setState(() {
            area = data['area'];
            street = data['street'];
            building = data['building'];
            apartment = data['apartment'];
          });
        } else {
          print('Latitude or longitude is null.');
        }
      } else {
        print('No location details found for this user.');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> fetchUserNewLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('NewLocationDetails')
          .get(); // Removed limit(1)

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          newLocations = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        print('No location details found for this user.');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        appBar: AppBar(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            'Saved Address',
            style: GoogleFonts.castoro(
                fontSize: 20,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F4F4),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(10, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_pin,
                              color: ApplicationColor, size: 30),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "$area, $street, $building building, apartment no.$apartment",
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
                              setState(() {
                                selectedIndex = -1; // Select the first location
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ApplicationColor,
                                  width: 2,
                                ),
                              ),
                              child: selectedIndex == -1
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ApplicationColor,
                                          border: Border.all(
                                            color: ApplicationColor,
                                            width: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newLocations.length,
                  itemBuilder: (context, index) {
                    final location = newLocations[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F4F4),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(10, 10))
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_pin,
                                color: ApplicationColor, size: 30),
                            const SizedBox(width: 8),
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
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ApplicationColor,
                                    width: 2,
                                  ),
                                ),
                                child: selectedIndex == index
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ApplicationColor,
                                            border: Border.all(
                                              color: ApplicationColor,
                                              width: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                GradientButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Posting..",
                        backgroundColor: ApplicationColorWithOpacity,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Fluttertoast.showToast(
                          msg: "Posted",
                          backgroundColor: ApplicationColorWithOpacity,
                          textColor: Colors.white,
                          fontSize: 16.0,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                        );
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeClientLayout(),
                          ));
                    },
                    text: "Post"),
                const SizedBox(height: 15),
                GradientButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GoogleMapNewScreenClient(),
                          ));
                    },
                    text: "Add A New Address"),
              ],
            ),
          ),
        ));
  }
}
