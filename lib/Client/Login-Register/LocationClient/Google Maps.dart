import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import '../../../Components/Buttons.dart';
import 'Google maps Components/Current Location Button.dart';
import 'Google maps Components/Map Widget.dart';
import 'Google maps Components/Search Bar.dart';
import 'Save_Address.dart';

class GoogleMapScreenClient extends StatefulWidget {
  const GoogleMapScreenClient({super.key});

  @override
  _GoogleMapScreenClientState createState() => _GoogleMapScreenClientState();
}

class _GoogleMapScreenClientState extends State<GoogleMapScreenClient> {
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;
  LatLng _currentLocation =
      LatLng(31.2001, 29.9187); // Default to Alexandria, Egypt
  String _streetName = "Unknown Street";
  String _areaName = "Unknown Area";

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Function to update location and fetch address
  void _updateLocation(LatLng newLocation) async {
    setState(() {
      _currentLocation = newLocation;
      _mapController.move(newLocation, 15.0);
    });

    await _fetchAddress(newLocation);
  }

  // Function to fetch address from coordinates using Reverse Geocoding API
  Future<void> _fetchAddress(LatLng location) async {
    final url = Uri.parse("https://nominatim.openstreetmap.org/reverse?"
        "lat=${location.latitude}&lon=${location.longitude}"
        "&format=json"
        "&addressdetails=1"
        "&zoom=16"
        "&accept-language=en");

    try {
      final response = await http.get(url,
          headers: {"User-Agent": "YourAppName/1.0 (your@email.com)"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] ?? {};

        setState(() {
          _streetName = address['road'] ?? "Unknown Street";

          // Check multiple fields for the suburb
          String suburb = address['suburb'] ??
              address['city_district'] ??
              address['neighbourhood'] ??
              address['hamlet'] ?? // Add hamlet as a backup
              address['village'] ??
              address['town'] ??
              "";

          String city = address['city'] ??
              address['county'] ??
              address['state'] ??
              "Unknown City";

          // If suburb is found, include it
          if (suburb.isNotEmpty) {
            _areaName = "$city, $suburb";
          } else {
            _areaName = city;
          }

          _searchController.text = "$_streetName, $_areaName";
          if (kDebugMode) {
            print("Street Name: $_streetName");
          }
          print("Area Name: $_areaName");
        });
      } else {
        print("Reverse Geocoding Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Reverse Geocoding Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          MapWidget(
            mapController: _mapController,
            currentLocation: _currentLocation,
            onMapTap: _updateLocation,
          ),

          // Search Bar
          SearchBarLocation(
            searchController: _searchController,
            onLocationSelected: (location) {
              if (location != null) {
                LatLng newLocation = LatLng(
                  double.parse(location['latitude']),
                  double.parse(location['longitude']),
                );
                _updateLocation(newLocation);
              }
            },
          ),

          // Current Location Button
          CurrentLocationButton(onLocationUpdated: _updateLocation),
          // Save Address Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaveAddressScreenClient(
                            areaName: _areaName,
                            streetName: _streetName,
                            latitude: _currentLocation.latitude,
                            longitude: _currentLocation.longitude,
                          )),
                );
              },
              text: "Enter Completed Address".tr(),
            ),
          )
        ],
      ),
    );
  }
}
