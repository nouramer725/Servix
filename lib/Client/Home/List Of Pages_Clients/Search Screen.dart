import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Service/Care/Care.dart';
import 'package:servix/Client/Service/Delivery/Delivery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Service/Devices/Devices.dart';
import '../../Service/Home_Service/Home-Service.dart';
import '../../Service/Man/Man.dart';
import '../../Service/Private_Teaching/Private-Teaching.dart';
import '../../Service/Woman/Woman.dart';
import '../HomeComponents/Model/service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredServices = [];
  List<String> recentSearches = [];
  List<Service> Services = Allservices;
  List<SubService> SubServices = [];
  String searchQuery = "";


  @override
  void initState() {
    super.initState();
    loadRecentSearches();
  }

  // Function to save search to recent searches
  void saveSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(search)) {
      recentSearches.insert(0, search);
      await prefs.setStringList('recentSearches', recentSearches);
    }
    setState(() {});
  }

  // Function to load recent searches
  void loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  // Function to remove a recent search
  void removeSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentSearches.remove(search);
    await prefs.setStringList('recentSearches', recentSearches);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: GoogleFonts.castoro(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onChanged: searchService,
              onSubmitted: (value) {
                if (value.isNotEmpty) saveSearch(value);
              },
              decoration: InputDecoration(
                hintText: "Search for services",
                hintStyle: GoogleFonts.castoro(
                    fontSize: 20, color: const Color(0xFFA9A9A9)),
                suffixIcon: const Icon(Icons.search, color: Color(0xFFE0DFDF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Visibility(
                visible: searchQuery.isNotEmpty, // ✅ Show only when search bar is not empty
                child: Expanded(
                  child: Services.isNotEmpty
                      ? ListView.builder(
                    itemCount: Services.length,
                    itemBuilder: (context, index) {
                      final service = Services[index];

                      // Check if the query matches any subservice
                      final matchingSubServices = service.subServices
                          .where((subService) => subService.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show the main service if its title matches
                          if (service.title
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(service.image),
                                radius: 30,
                              ),
                              title: Text(service.title),
                            ),

                          // Show subservices that match the query
                          if (matchingSubServices.isNotEmpty)
                            ...matchingSubServices.map((subService) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(subService.image),
                                radius: 25,
                              ),
                              title: Text(subService.title),
                              subtitle: Text("(${service.title})"), // Show parent service name
                            )),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No results found",
                          style: GoogleFonts.castoro(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Which service do you need today?",
              style: GoogleFonts.cantataOne(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  serviceItem("assets/images/care/Elder.jpg", "Elder",
                      context, Careservice()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/delivery/school.jpg",
                      "School Delivery", context, DeliveryServices()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/devices/Washing.jpg",
                      "Washing Machine", context, DevicesMaintenaceService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/home-service/Carpentry.jpg",
                      "Carpentry", context, HomeService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/men/massage-man.jpg", "Massage",
                      context, Manservice()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem(
                      "assets/images/private-teaching/musical-instruments.jpg",
                      "Musical instruments",
                      context,
                      Privateteachingservice()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem(
                      "assets/images/home-service/Kitchentechnician.jpg",
                      "Kitchen Technician",
                      context,
                      HomeService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/woman/nails.jpg", "Nails",
                      context, Womenservice()),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Recent Searches Section
            if (recentSearches.isNotEmpty) ...[
              Text(
                "Recent Searches:",
                style: GoogleFonts.cantataOne(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(recentSearches[index],
                          style: GoogleFonts.castoro(fontSize: 20)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => removeSearch(recentSearches[index]),
                      ),
                      onTap: () {
                        searchController.text = recentSearches[index];
                        searchService(recentSearches[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget serviceItem(String imagePath, String title, BuildContext context,
      Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 30,
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: GoogleFonts.castoro(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void searchService(String query) {
    final input = query.toLowerCase();
    searchQuery = input;
    final suggestions = Allservices.where((service) {
      final serviceTitle = service.title.toLowerCase();
      final hasMatchingSubService = service.subServices.any((subService) =>
          subService.title.toLowerCase().contains(input));

      return serviceTitle.contains(input) || hasMatchingSubService;
    }).toList();

    setState(() => Services = suggestions);
  }

}
