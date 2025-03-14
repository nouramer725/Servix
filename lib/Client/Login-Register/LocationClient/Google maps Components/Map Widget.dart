import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../constents/constent.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng currentLocation;
  final Function(LatLng) onMapTap;

  const MapWidget({
    Key? key,
    required this.mapController,
    required this.currentLocation,
    required this.onMapTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 12.0,
        interactionOptions: const InteractionOptions(
          flags: ~InteractiveFlag.rotate, // Disable rotation
        ),
        onTap: (tapPosition, latLng) {
          onMapTap(latLng);
        },
      ),
      children: [
        // OpenStreetMap tile layer
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),

        // Marker Layer for the selected location
        MarkerLayer(
          markers: [
            Marker(
              point: currentLocation,
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_on,
                color: ApplicationColor,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
