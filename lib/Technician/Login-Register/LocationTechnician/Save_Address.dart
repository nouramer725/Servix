import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:servix/Technician/Login-Register/Waiting%20Screen/Waiting_Screen.dart';

import '../../../Components/Buttons.dart';
import '../../../Components/location textfield.dart';
import '../../../constents/constent.dart';

class SaveAddressScreenTech extends StatefulWidget {
  final String areaName;
  final String streetName;
  final double latitude;
  final double longitude;
  final String phoneNumber;

  const SaveAddressScreenTech({
    Key? key,
    required this.areaName,
    required this.streetName,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _SaveAddressScreenTechState createState() => _SaveAddressScreenTechState();
}

class _SaveAddressScreenTechState extends State<SaveAddressScreenTech> {
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
      _buildingError =
          _buildingController.text.isEmpty ? 'Building Name is required' : null;
      _aptError = _aptController.text.isEmpty ? 'Apt. No. is required' : null;
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
      // Save the address in Firestore
      await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user!.uid)
          .collection("locationDetails")
          .add({
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

      print("Address saved successfully!");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingScreen(),
          ),
      );
    } catch (e) {
      print("Error saving address: $e");
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
          padding: const EdgeInsets.all(25.0),
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
                            child:  Icon(
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
                     Icon(Icons.location_pin,
                        color: ApplicationColor, size: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Area",
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
                  controller: _buildingController, label: 'Building Name'),
              if (_buildingError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(_buildingError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 12),

              // **Apt No & Floor (Apt No. is Required)**
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldLocation(
                        controller: _aptController, label: "Apt. no."),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormFieldLocation(
                        controller: _floorController,
                        label: "Floor (Optional)"),
                  ),
                ],
              ),
              if (_aptError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(_aptError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              const SizedBox(height: 12),

              // **Street Name (Read-Only)**
              CustomTextFormFieldLocation(
                  readOnly: true,
                  initialValue: widget.streetName,
                  label: "Street"),
              const SizedBox(height: 12),

              // **Additional Directions**
              CustomTextFormFieldLocation(
                  controller: _directionsController,
                  label: "Additional directions (optional)"),
              const SizedBox(height: 12),

              // **Phone Number**
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/location/Egypt.png",
                        width: 40, height: 40),
                    const SizedBox(width: 10),
                    Text("+20 ${widget.phoneNumber}",
                        style: GoogleFonts.inter(
                            fontSize: 15, color: const Color(0xFF545353))),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // **Label**
              CustomTextFormFieldLocation(
                  controller: _labelController,
                  label: "Address Label (optional)"),
              const SizedBox(height: 12),

              // **Save Address Button**
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  text: _isLoading ? "Saving..." : "Save Address",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
