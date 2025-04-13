import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../Components/Buttons.dart';
import '../../Components/location textfield.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({super.key});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  LatLng? userLocation;

  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
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
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        final lat = data['latitude'];
        final lng = data['longitude'];
        final area = data['area'];
        final street = data['street'];
        final building = data['building'];
        final apartment = data['apartment'];
        final floor = data['floor'];
        final directions = data['directions'];
        final label = data['label'];

        if (lat != null && lng != null) {
          setState(() {
            userLocation = LatLng(lat.toDouble(), lng.toDouble());
            _areaController.text = area;
            _streetController.text = street;
            _buildingController.text = building;
            _aptController.text = apartment;
            _floorController.text = floor;
            _directionsController.text = directions;
            _labelController.text = label;
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

  Future<void> updateUserLocation() async {
    setState(() => isLoading = true);

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
        final docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('user-files')
            .doc(userId)
            .collection('NewLocationDetails')
            .doc(docId)
            .update({
          'latitude': userLocation?.latitude,
          'longitude': userLocation?.longitude,
          'area': _areaController.text.trim(),
          'street': _streetController.text.trim(),
          'building': _buildingController.text.trim(),
          'apartment': _aptController.text.trim(),
          'floor': _floorController.text.trim(),
          'directions': _directionsController.text.trim(),
          'label': _labelController.text.trim(),
        });

        Fluttertoast.showToast(
          msg: 'Address updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
        );
      } else {
        // If no document exists, create one
        await FirebaseFirestore.instance
            .collection('user-files')
            .doc(userId)
            .collection('NewLocationDetails')
            .add({
          'latitude': userLocation?.latitude,
          'longitude': userLocation?.longitude,
          'area': _areaController.text.trim(),
          'street': _streetController.text.trim(),
          'building': _buildingController.text.trim(),
          'apartment': _aptController.text.trim(),
          'floor': _floorController.text.trim(),
          'directions': _directionsController.text.trim(),
          'label': _labelController.text.trim(),
        });

        Fluttertoast.showToast(
          msg: 'Address added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating address: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteUserAddress() async {
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
        final docId = querySnapshot.docs.first.id;

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
          backgroundColor: Colors.red.withOpacity(0.8),
          textColor: Colors.white,
        );

        // Optionally pop or refresh
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'No address found to delete',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Edit Address".tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0,left: 25),
            child: GestureDetector(
              onTap: () {
                deleteUserAddress();
              },
              child: Text(
                "Delete".tr(),
                style: GoogleFonts.castoro(
                  fontSize: 20,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : ApplicationColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: userLocation == null
          ? Center(
              child: CircularProgressIndicator(
              color: ApplicationColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (isLoading)
                      LinearProgressIndicator(
                        color: ApplicationColor,
                      ),
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          const BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: userLocation!,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: userLocation!,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: ApplicationColor,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormFieldLocation(
                      controller: _areaController,
                      label: 'Area'.tr(),
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),

                    CustomTextFormFieldLocation(
                        controller: _buildingController,
                        label: 'Building Name'.tr()),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormFieldLocation(
                              controller: _aptController,
                              label: "Apt. no.".tr()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormFieldLocation(
                              controller: _floorController,
                              label: "Floor (Optional)".tr()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    CustomTextFormFieldLocation(
                        controller: _streetController,
                        readOnly: true,
                        label: "Street".tr()),
                    const SizedBox(height: 12),

                    CustomTextFormFieldLocation(
                        controller: _directionsController,
                        label: "Additional directions (optional)".tr()),
                    const SizedBox(height: 12),

                    // **Label**
                    CustomTextFormFieldLocation(
                        controller: _labelController,
                        label: "Address Label (optional)".tr()),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 10),
        child: GradientButton(
            onPressed: updateUserLocation, text: "Update Address".tr()),
      ),
    );
  }
}
