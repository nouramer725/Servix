import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
            'Devices Maintenance'.tr(),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/devices.png'),
                alignment: Alignment.centerRight,
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Mobile', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Air Conditioning', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Computer', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Fridge', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Washing Machine', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Stove', // Custom title
                        imagePath:
                            'assets/images/devices/stove.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Screen'.tr(),
                imagePath: 'assets/images/devices/screen.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Screen', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Microwave', // Custom title
                        imagePath:
                            'assets/images/devices/microwave.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Water Heating'.tr(),
                imagePath: 'assets/images/devices/water-heating.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Water Heating', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Fan', // Custom title
                        imagePath:
                            'assets/images/devices/fan.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            // ServiceCard(
            //   serviceName: 'Refrigerator'.tr(),
            //   imagePath: 'assets/images/devices/refrigerator.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Coffee Machine'.tr(),
            //   imagePath: 'assets/images/devices/coffee_machine.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Toaster'.tr(),
            //   imagePath: 'assets/images/devices/toaster.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Iron'.tr(),
            //   imagePath: 'assets/images/devices/iron.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Vacuum Cleaner'.tr(),
            //   imagePath: 'assets/images/devices/vacuum_cleaner.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Air Fryer'.tr(),
            //   imagePath: 'assets/images/devices/air_fryer.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Electric Kettle'.tr(),
            //   imagePath: 'assets/images/devices/electric_kettle.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Sewing Machine'.tr(),
            //   imagePath: 'assets/images/devices/sewing_machine.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Blender'.tr(),
            //   imagePath: 'assets/images/devices/blender.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
