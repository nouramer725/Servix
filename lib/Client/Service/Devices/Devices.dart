import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class DevicesMaintenaceService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xff69B5BB),
          title: Text(
            'Devices Service'.tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/home/devices.png'),
                alignment: context.locale.languageCode == 'ar'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ServiceCard(
                serviceName: 'Mobile'.tr(),
                imagePath: 'assets/images/devices/mobile.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Mobile'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/mobile.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Air Conditioning'.tr(),
                imagePath: 'assets/images/devices/air.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Air Conditioning'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/air.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Computer'.tr(),
                imagePath: 'assets/images/devices/computer.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Computer'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/computer.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Fridge'.tr(),
                imagePath: 'assets/images/devices/fridge.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Fridge'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/fridge.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Washing Machine'.tr(),
                imagePath: 'assets/images/devices/Washing.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Washing Machine'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/Washing.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Stove'.tr(),
                imagePath: 'assets/images/devices/stove.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Stove'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/stove.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Screens'.tr(),
                imagePath: 'assets/images/devices/screen.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Screens'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/screen.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Microwave'.tr(),
                imagePath: 'assets/images/devices/microwave.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Microwave'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/microwave.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Water Heater'.tr(),
                imagePath: 'assets/images/devices/water-heating.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Water Heater'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/water-heating.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Fan'.tr(),
                imagePath: 'assets/images/devices/fan.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Fan'.tr(), // Custom title
                        imagePath:
                            'assets/images/devices/fan.jpg', // Custom image
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
