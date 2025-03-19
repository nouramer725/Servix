import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../constents/constent.dart';

class SearchBarLocation extends StatefulWidget {
  final TextEditingController searchController;
  final Function(Map<String, dynamic>?) onLocationSelected;

  const SearchBarLocation({
    Key? key,
    required this.searchController,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _SearchBarLocationState createState() => _SearchBarLocationState();
}

class _SearchBarLocationState extends State<SearchBarLocation> {
  List<Map<String, dynamic>> locationResults = [];
  bool isLoading = false;

  Future<void> getLocationSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => locationResults = []);
      return;
    }

    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5";

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            locationResults =
                data
                    .map<Map<String, dynamic>>(
                      (result) => {
                        "label": result['display_name'],
                        "latitude": result['lat'],
                        "longitude": result['lon'],
                      },
                    )
                    .toList();
          });
        } else {
          setState(() => locationResults = []);
        }
      } else {
        setState(() => locationResults = []);
      }
    } catch (e) {
      print("Error fetching suggestions: $e".tr());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.white,
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: ApplicationColor,
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: widget.searchController,
                        onChanged: (query) {
                          getLocationSuggestions(query);
                          setState(() {}); // Refresh the widget when typing
                        },
                        decoration: InputDecoration(
                          hintText: "Search for a location".tr(),
                          hintStyle: GoogleFonts.cantataOne(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        widget.searchController.text.isEmpty
                            ? Icons.search // Show search icon when empty
                            : Icons.clear, // Show clear icon when typing
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        if (widget.searchController.text.isNotEmpty) {
                          widget.searchController.clear();
                          setState(() => locationResults = []); // Clear suggestions
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (isLoading) const LinearProgressIndicator(),
              if (locationResults.isNotEmpty)
                Container(
                  color: Colors.white,
                  child: Column(
                    children: locationResults
                        .map(
                          (location) => ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(location['label']),
                        onTap: () {
                          widget.searchController.text = location['label'];
                          widget.onLocationSelected(location);
                          setState(() => locationResults = []);
                        },
                      ),
                    )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
