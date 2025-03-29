import 'package:flutter/material.dart';

import '../../../Components/service_card.dart';

class DevicesMaintenaceService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xff69B5BB),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {},
          // ),
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Devices \nMaintenace',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
              serviceName: 'Mobile',
              imagePath: 'assets/images/devices/mobile.jpg',
            ),
            ServiceCard(
              serviceName: 'Air Conditioning',
              imagePath: 'assets/images/devices/air.jpg',
            ),
            ServiceCard(
              serviceName: 'Computer',
              imagePath: 'assets/images/devices/computer.jpg',
            ),
            ServiceCard(
              serviceName: 'Fridge',
              imagePath: 'assets/images/devices/fridge.jpg',
            ),
            ServiceCard(
              serviceName: 'Washing Machine',
              imagePath: 'assets/images/devices/Washing.jpg',
            ),
            ServiceCard(
              serviceName: 'Stove',
              imagePath: 'assets/images/devices/stove.jpg',
            ),
            ServiceCard(
              serviceName: 'Screen',
              imagePath: 'assets/images/devices/screen.jpg',
            ),
            ServiceCard(
              serviceName: 'Microwave',
              imagePath: 'assets/images/devices/microwave.jpg',
            ),
            ServiceCard(
              serviceName: 'Water Heating',
              imagePath: 'assets/images/devices/water-heating.jpg',
            ),
            ServiceCard(
              serviceName: 'Fan',
              imagePath: 'assets/images/devices/fan.jpg',
            ),
          ],
        ),
      ),
    );
  }
}