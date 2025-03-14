import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../constents/constent.dart';

class CurrentLocationButton extends StatelessWidget {
  final Function(LatLng) onLocationUpdated;

  const CurrentLocationButton({required this.onLocationUpdated});

  Future<void> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enable location services.")));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location permission denied.")));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permissions are permanently denied.")),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      onLocationUpdated(LatLng(position.latitude, position.longitude));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: ApplicationColor,
        child: Icon(Icons.my_location, color: Colors.white),
        onPressed: () => _getCurrentLocation(context),
      ),
    );
  }
}
