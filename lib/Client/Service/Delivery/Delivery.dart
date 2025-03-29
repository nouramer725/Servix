import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class DeliveryServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffA52754),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            'Delivery \nServices',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/delivery.png'),
                alignment: Alignment.centerRight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ServiceCard(
              serviceName: 'School delivert',
              imagePath: 'assets/images/delivery/school.jpg',
            ),
            ServiceCard(
              serviceName: 'Spend',
              imagePath: 'assets/images/delivery/spend.jpg',
            ),
            ServiceCard(
              serviceName: 'Taxi',
              imagePath: 'assets/images/delivery/Taxi.jpg',
            ),
            ServiceCard(
              serviceName: 'Bus',
              imagePath: 'assets/images/delivery/bus.jpg',
            ),
            ServiceCard(
              serviceName: 'Truck',
              imagePath: 'assets/images/delivery/truck.jpg',
            ),
            ServiceCard(
              serviceName: 'Scooter',
              imagePath: 'assets/images/delivery/scooter.jpg',
            ),
            ServiceCard(
              serviceName: 'Loader Truck',
              imagePath: 'assets/images/delivery/loader.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
