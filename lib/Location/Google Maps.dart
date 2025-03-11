import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // 📍 Import Geolocator
import '../Components/Buttons.dart';
import 'Save_Address.dart';

class GoogleMap extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  final String positionStackApiKey = "5e26cf622dace109a1c6deac653d9705";
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;
  LatLng _currentLocation = LatLng(31.2001, 29.9187);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // 🔹 Search Function (Works with Any Place)
  Future<void> searchLocation(String query) async {
    final url =
        "http://api.positionstack.com/v1/forward?access_key=$positionStackApiKey&query=$query&limit=3";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final result = data['data'][0];
          double lat = result['latitude'];
          double lon = result['longitude'];

          setState(() {
            _currentLocation = LatLng(lat, lon);
            _mapController.move(_currentLocation, 15.0);
          });
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Location not found")));
        }
      } else {
        throw Exception("Failed to fetch location");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location")));
    }
  }

  // 🔹 Update Location When User Clicks on Map
  void _updateLocationOnTap(LatLng tappedLocation) {
    setState(() {
      _currentLocation = tappedLocation;
      _mapController.move(_currentLocation, 15.0);
    });
  }

  // 📍 Get Current Location and Move Map
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Location services are disabled. Please enable them in settings.",
          ),
        ),
      );
      return null; // 🔹 Return null instead of void
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location permission denied. Please allow access."),
          ),
        );
        return null; // 🔹 Return null if permission is denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Location permissions are permanently denied. Enable them in settings.",
          ),
        ),
      );
      return null; // 🔹 Return null for permanently denied permissions
    }

    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation, 15.0);
      });

      return position; // 🔹 Now returns a Position instead of void
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location: $e")));
      return null; // 🔹 Handle errors gracefully
    }
  }

  Future<List<String>> getLocationSuggestions(String query) async {
    final url =
        "http://api.positionstack.com/v1/forward?access_key=$positionStackApiKey&query=$query&limit=5";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          return data['data']
              .map<String>((result) => result['label'] as String)
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📍 OpenStreetMap Widget with Tap Interaction
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 12.0,
              onTap: (tapPosition, latLng) => _updateLocationOnTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
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

          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7,vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(3, 9),
                  ),
                ],
              ),
              child: TypeAheadField(
                controller: _searchController, // Use controller directly
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Search for location",
                      hintStyle: GoogleFonts.cantataOne(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.location_pin,
                        color: Color(0xFF821717),
                        size: 30,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await getLocationSuggestions(pattern);
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    leading: Icon(Icons.location_on, color: Colors.black54),
                    title: Text(suggestion),
                  );
                },
                onSelected: (String suggestion) {
                  _searchController.text = suggestion;
                  searchLocation(suggestion);
                },
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GradientButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Selected Location: $_currentLocation"),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaveAddressScreen()),
                );
              },
              text: "Enter Completed Address",
            ),
          ),

          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF821717),
              child: Icon(Icons.my_location, color: Colors.white),
              onPressed: () async {
                Position? position = await _getCurrentLocation();
                if (position == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not retrieve location.")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
