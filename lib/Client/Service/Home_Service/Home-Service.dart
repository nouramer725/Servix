import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class HomeService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffE57D38),
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the back button
          ),
          title: Text(
            'Home Service',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/home-service.png'),
                fit: BoxFit.cover,
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
              serviceName: 'Cleaning',
              imagePath: 'assets/images/home-service/cleaning.jpg',
            ),
            ServiceCard(
              serviceName: 'Carpentry',
              imagePath: 'assets/images/home-service/Carpentry.jpg',
            ),
            ServiceCard(
              serviceName: 'Electricity',
              imagePath: 'assets/images/home-service/Electricity.jpg',
            ),
            ServiceCard(
              serviceName: 'Plumbing',
              imagePath: 'assets/images/home-service/Plumbing.jpg',
            ),
            ServiceCard(
              serviceName: 'Kitchen Technician',
              imagePath: 'assets/images/home-service/Kitchentechnician.jpg',
            ),
            ServiceCard(
              serviceName: 'Painting',
              imagePath: 'assets/images/home-service/painting.jpg',
            ),
            ServiceCard(
              serviceName: 'Camera Technician',
              imagePath: 'assets/images/home-service/camera.jpg',
            ),
            ServiceCard(
              serviceName: 'Landscaper',
              imagePath: 'assets/images/home-service/LandScaper.jpg',
            ),
          ],
        ),
      ),
    );
  }
}