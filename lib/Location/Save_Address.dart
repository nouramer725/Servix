import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../Components/Buttons.dart';
import '../Components/location textfield.dart';

class SaveAddressScreen extends StatefulWidget {
  final String areaName;
  final String streetName;
  final double latitude;
  final double longitude;

  const SaveAddressScreen({
    Key? key,
    required this.areaName,
    required this.streetName,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  String? _buildingError;
  String? _aptError;

  /// **Validation Function**
  bool _validateFields() {
    setState(() {
      _buildingError =
          _buildingController.text.isEmpty ? 'Building Name is required' : null;
      _aptError = _aptController.text.isEmpty ? 'Apt. No. is required' : null;
    });

    return _buildingError == null && _aptError == null;
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

              // Map Preview Container
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
                              color: Color(0xFF821717),
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

              // Area & Street Name
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F4F4),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Color(0xFF821717),
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Area",
                          style: GoogleFonts.charisSil(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.areaName,
                          style: GoogleFonts.castoro(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF676565),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Building Name (Required)
              CustomTextFormFieldLocation(
                controller: _buildingController,
                label: 'Building Name',
              ),
              if (_buildingError != null) ...[
                SizedBox(height: 5),
                Text(
                  _buildingError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              const SizedBox(height: 12),

              // Apt No & Floor (Apt No. is Required)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormFieldLocation(
                          controller: _aptController,
                          label: "Apt. no.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormFieldLocation(
                      controller: _floorController,
                      label: "Floor (Optional)",
                    ),
                  ),
                ],
              ),
              if (_aptError != null) ...[
                SizedBox(height: 5),
                Text(
                  _aptError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              const SizedBox(height: 12),

              // Street Name (Read-Only)
              CustomTextFormFieldLocation(
                readOnly: true,
                initialValue: widget.streetName,
                label: "Street",
              ),
              const SizedBox(height: 12),

              // Additional Directions
              CustomTextFormFieldLocation(
                controller: _directionsController,
                label: "Additional directions (optional)",
              ),
              const SizedBox(height: 12),

              // Label
              CustomTextFormFieldLocation(
                controller: _labelController,
                label: "Label (optional)",
              ),
              const SizedBox(height: 12),

              // Save Address Button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    if (_validateFields()) {
                      print("Address saved successfully!");
                    }
                  },
                  text: "Save Address",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
