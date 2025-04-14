import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Service/Care/Care.dart';
import 'package:servix/Client/Service/Delivery/Delivery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Theme/Theme_Provider.dart';
import '../../Service/Devices/Devices.dart';
import '../../Service/Home_Service/Home-Service.dart';
import '../../Service/Man/Man.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search'.tr(),
          style: GoogleFonts.castoro(fontSize: 25, fontWeight: FontWeight.bold, color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
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
              style: TextStyle(
                color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black , // Automatically changes based on theme
              ),
              onChanged: searchService,
              onSubmitted: (value) {
                if (value.isNotEmpty) saveSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for services'.tr(),
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
                              title: Text(service.title, style: GoogleFonts.castoro(fontSize: 20, color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
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
                              subtitle: Text("(${service.title})", style: GoogleFonts.castoro(fontSize: 14, color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black)), // Show parent service name
                            )),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No results found".tr(),
                            style: GoogleFonts.castoro(fontSize: 18, color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Which service do you need today?".tr(),
              style: GoogleFonts.cantataOne(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  serviceItem("assets/images/care/Elder.jpg", "Elder".tr(),
                      context, Careservice()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/delivery/school.jpg",
                      "School Delivery".tr(), context, DeliveryServices()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/devices/Washing.jpg",
                      "Washing Machine".tr(), context, DevicesMaintenaceService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/home-service/Carpentry.jpg",
                      "Carpentry".tr(), context, HomeService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/men/massage-man.jpg", "Massage".tr(),
                      context, Manservice()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem(
                      "assets/images/home-service/Kitchentechnician.jpg",
                      "Kitchen Technician".tr(),
                      context,
                      HomeService()),
                  const SizedBox(
                    width: 5,
                  ),
                  serviceItem("assets/images/woman/nails.jpg", "Nails".tr(),
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
                "Recent Searches:".tr(),
                style: GoogleFonts.cantataOne(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:  Icon(Icons.history,color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                      title: Text(recentSearches[index],
                          style: GoogleFonts.castoro(fontSize: 20, color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              style: GoogleFonts.castoro(fontSize: 14,color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
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
