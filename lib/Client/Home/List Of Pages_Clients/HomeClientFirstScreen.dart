import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Client/Service/Care/Care.dart';
import 'package:servix/Client/Service/Devices/Devices.dart';
import 'package:servix/Client/Service/Private_Teaching/Private-Teaching.dart';
import 'package:servix/Client/Service/Woman/Woman.dart';
import '../../Service/Delivery/Delivery.dart';
import '../../Service/Home_Service/Home-Service.dart';
import '../../Service/Man/Man.dart';
import '../HomeComponents/Model/Category.dart';
import '../HomeComponents/category_item.dart';
import 'Search Screen.dart';

class HomeClientFirstScreen extends StatefulWidget {
  const HomeClientFirstScreen({super.key});

  @override
  State<HomeClientFirstScreen> createState() => _HomeClientFirstScreenState();
}

class _HomeClientFirstScreenState extends State<HomeClientFirstScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<Category> categories = const [
    Category(
      categoryname: 'Home \nService',
      image: 'assets/images/home/home-service2.png',
      color: Color(0xFFE37D3E),
      height: 160,
    ),
    Category(
      categoryname: 'Private \nTeaching',
      image: 'assets/images/home/private_teaching3.png',
      color: Color(0xFFB93434),
      height: 160,
    ),
    Category(
      categoryname: 'Care \nService',
      image: 'assets/images/home/care.png',
      color: Color(0xFFF7C86E),
      height: 160,
    ),
    Category(
      categoryname: 'For \nMen',
      image: 'assets/images/home/man.png',
      color: Color(0xFF305D67),
      height: 160,
    ),
    Category(
      categoryname: 'For \nWomen',
      image: 'assets/images/home/woman.png',
      color: Color(0xFFC37B7B),
      height: 160,
    ),
    Category(
      categoryname: 'Devices\nMaintenance',
      image: 'assets/images/home/devices.png',
      color: Color(0xFF69B5BB),
      height: 160,
    ),
    Category(
      categoryname: 'Delivery\nService',
      image: 'assets/images/home/delivery.png',
      color: Color(0xFFA52754),
      height: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: AbsorbPointer(
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search for services",
                  hintStyle: GoogleFonts.castoro(fontSize: 20, color: const Color(0xFFA9A9A9)),
                  suffixIcon: const Icon(Icons.search, color: Color(0xFFE0DFDF)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        CategoryItem(
            category: categories[0],
            index: 0,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeService()));
            }),
        CategoryItem(
          category: categories[1],
          index: 1,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Privateteachingservice()));
            }
        ),
        CategoryItem(
          category: categories[2],
          index: 2,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Careservice()));
            }
        ),
        CategoryItem(
          category: categories[3],
          index: 3,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Manservice()));
            }
        ),
        CategoryItem(
          category: categories[4],
          index: 4,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Womenservice()));
            }
        ),
        CategoryItem(
          category: categories[5],
          index: 5,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DevicesMaintenaceService()));
            }
        ),
        CategoryItem(
          category: categories[6],
          index: 6,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DeliveryServices()));
            }
        ),
      ],
    )

        // Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(20),
        //       child: SearchBar(
        //         textInputAction:
        //         TextInputAction.search,
        //         trailing: const [
        //           Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Icon(Icons.search_outlined
        //           ,color: Color(0xFFE0DFDF),
        //           size: 30,
        //           ),
        //         ),
        //         ],
        //         hintText: 'Search for servers',
        //         backgroundColor: WidgetStatePropertyAll(Colors.white),
        //         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        //           side: BorderSide(color: Color(0xFFE0DFDF),
        //           width: 2
        //           ),
        //         borderRadius: BorderRadius.circular(25),
        //         ),
        //         ),
        //         elevation: WidgetStatePropertyAll(10),
        //         padding: WidgetStatePropertyAll(
        //            EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
        //         ),
        //         ),
        //     ),

        );
  }
}
