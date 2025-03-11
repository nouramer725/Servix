import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Login-Register/Sign_In_Client.dart';
import '../Components/Buttons.dart';
import '../Components/location textfield.dart';

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
              // Area & Street Name
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F4F4),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Color(0xFF821717)),
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
                          "Kafr Abdo",
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
              // Building Name
              CustomTextFormFieldLocation(
                controller: _buildingController,
                label: 'Building Name',
              ),
              const SizedBox(height: 12),

              // Apt No & Floor
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldLocation(
                      controller: _aptController,
                      label: "Apt. no.",
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
              const SizedBox(height: 12),

              // Street Name (Read-Only)
              CustomTextFormFieldLocation(
                readOnly: true,
                initialValue: "Mahmoud Abou El Ela",
                label: "Street",
              ),
              const SizedBox(height: 12),

              // Additional Directions
              CustomTextFormFieldLocation(
                controller: _directionsController,
                label: "Additional directions (optional)",
              ),
              const SizedBox(height: 12),

              // Phone Number
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/location/Egypt.png",
                      width: 40,
                      height: 40,
                    ), // Ensure the asset exists
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF545353)),
                        ),
                        Text(
                          "+20 1274554479",
                          style: GoogleFonts.inter(fontSize: 15,color: Color(0xFF545353)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Address Label
              CustomTextFormFieldLocation(
                controller: _labelController,
                label: "Address label (Optional)",
              ),
              const SizedBox(height: 20),

              // Save Address Button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    final String userType = ModalRoute.of(context)!.settings.arguments as String;
                    if (userType == "client") {
                      Navigator.pushReplacementNamed(context, '/signInClient');
                    } else if (userType == "technician") {
                      Navigator.pushReplacementNamed(context, '/signInTechnician');
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
