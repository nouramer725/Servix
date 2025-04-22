import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../../../Components/location textfield.dart';
import '../../../../constents/constent.dart';
import '../../Theme/Theme_Provider.dart';

class SaveNewAddressIconLocationInProfile extends StatefulWidget {
  final String areaName;
  final String streetName;
  final double latitude;
  final double longitude;
  final String? building;
  final String? apt;
  final String? floor;
  final String? directions;
  final String? label;

  const SaveNewAddressIconLocationInProfile({
    Key? key,
    required this.areaName,
    required this.streetName,
    required this.latitude,
    required this.longitude,
    this.building,
    this.apt,
    this.floor,
    this.directions,
    this.label,
  }) : super(key: key);

  @override
  _SaveNewAddressIconLocationInProfileState createState() =>
      _SaveNewAddressIconLocationInProfileState();
}

class _SaveNewAddressIconLocationInProfileState
    extends State<SaveNewAddressIconLocationInProfile> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  String? _buildingError;
  String? _aptError;

  @override
  void initState() {
    super.initState();
    _buildingController.text = widget.building ?? '';
    _aptController.text = widget.apt ?? '';
    _floorController.text = widget.floor ?? '';
    _directionsController.text = widget.directions ?? '';
    _labelController.text = widget.label ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text("Location Details".tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  readOnly: true,
                  controller: _buildingController,
                  label: 'Building Name'.tr()),
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
                        readOnly: true,
                        controller: _aptController,
                        label: "Apt. no.".tr()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormFieldLocation(
                        readOnly: true,
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
              CustomTextFormFieldLocation(
                  readOnly: true,
                  controller: _directionsController,
                  label: "Additional directions (optional)".tr()),
              const SizedBox(height: 12),
              // **Label**
              CustomTextFormFieldLocation(
                  readOnly: true,
                  controller: _labelController,
                  label: "Address Label (optional)".tr()),
            ],
          ),
        ),
      ),
    );
  }
}
