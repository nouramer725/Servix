import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:servix/Components/Buttons.dart';

class SaveAddressScreen extends StatefulWidget {
  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  LatLng _initialPosition =
      const LatLng(31.2001, 29.9187); // Default: Alexandria, Egypt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Save Address"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Google Map View
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    const BoxShadow(color: Colors.black26, blurRadius: 5)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected_location"),
                        position: _initialPosition,
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Area & Street Name
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.red),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Area",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text("Kafr Abdo",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Building Name
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(
                  labelText: "Building Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Apt No & Floor
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _aptController,
                      decoration: const InputDecoration(
                        labelText: "Apt. no.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _floorController,
                      decoration: const InputDecoration(
                        labelText: "Floor (Optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Street Name
              TextFormField(
                readOnly: true,
                initialValue: "Mahmoud Abou El Ela",
                decoration: const InputDecoration(
                  labelText: "Street",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Additional Directions
              TextFormField(
                controller: _directionsController,
                decoration: const InputDecoration(
                  labelText: "Additional directions (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Phone Number
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/images/location/Egypt.png",
                        width: 24), // Add an Egypt flag image to assets
                    const SizedBox(width: 8),
                    const Text("+20 1274554479",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Address Label
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: "Address label (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Save Address Button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                    onPressed: () {
                      // Handle address saving logic
                    },
                    text: "Save Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
