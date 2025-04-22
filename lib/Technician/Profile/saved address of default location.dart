import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../Components/Buttons.dart';
import '../../../../Components/location textfield.dart';
import '../../../../constents/constent.dart';

class SaveNewAddressDefaultLocationTech extends StatefulWidget {
  final String areaName;
  final String streetName;
  final double latitude;
  final double longitude;

  const SaveNewAddressDefaultLocationTech({
    Key? key,
    required this.areaName,
    required this.streetName,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _SaveNewAddressDefaultLocationTechState createState() =>
      _SaveNewAddressDefaultLocationTechState();
}

class _SaveNewAddressDefaultLocationTechState
    extends State<SaveNewAddressDefaultLocationTech> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  String? _buildingError;
  String? _aptError;
  bool _isLoading = false;

  bool _validateFields() {
    setState(() {
      _buildingError = _buildingController.text.isEmpty
          ? 'Building Name is required'.tr()
          : null;
      _aptError =
          _aptController.text.isEmpty ? 'Apt. No. is required'.tr() : null;
    });

    return _buildingError == null && _aptError == null;
  }

  Future<void> _saveAddress() async {
    if (!_validateFields()) return;

    if (user == null) {
      print("Error: No user logged in.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user!.uid)
          .collection("locationDetails")
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentReference docRef = snapshot.docs.first.reference;

        await docRef.update({
          "building": _buildingController.text.trim(),
          "apartment": _aptController.text.trim(),
          "floor": _floorController.text.trim(),
          "directions": _directionsController.text.trim(),
          "label": _labelController.text.trim(),
          "area": widget.areaName,
          "street": widget.streetName,
          "latitude": widget.latitude,
          "longitude": widget.longitude,
          "timestamp": FieldValue.serverTimestamp(),
        });

        print("Address updated successfully!");
      } else {
        print("No address document found to update.");
      }

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print("Error updating address: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // **Map Preview**
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
                      initialCenter: LatLng(widget.latitude, widget.longitude),
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
                            point: LatLng(widget.latitude, widget.longitude),
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
              const SizedBox(height: 16),

              // **Area & Street Name**
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F4F4),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: ApplicationColor, size: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Area".tr(),
                            style: GoogleFonts.charisSil(
                                fontSize: 20, color: Colors.grey),
                          ),
                          Text(
                            widget.areaName,
                            style: GoogleFonts.castoro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF676565),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // **Building Name (Required)**
              CustomTextFormFieldLocation(
                  controller: _buildingController, label: 'Building Name'.tr()),
              if (_buildingError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(_buildingError!.tr(),
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 12),

              // **Apt No & Floor (Apt No. is Required)**
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldLocation(
                        controller: _aptController, label: "Apt. no.".tr()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormFieldLocation(
                        controller: _floorController,
                        label: "Floor (Optional)".tr()),
                  ),
                ],
              ),
              if (_aptError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(_aptError!.tr(),
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 12),

              // **Street Name (Read-Only)**
              CustomTextFormFieldLocation(
                  readOnly: true,
                  initialValue: widget.streetName,
                  label: "Street".tr()),
              const SizedBox(height: 12),

              // **Additional Directions**
              CustomTextFormFieldLocation(
                  controller: _directionsController,
                  label: "Additional directions (optional)".tr()),
              const SizedBox(height: 12),

              // **Label**
              CustomTextFormFieldLocation(
                  controller: _labelController,
                  label: "Address Label (optional)".tr()),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  text: _isLoading ? "Saving...".tr() : "Save Address".tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
