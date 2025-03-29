import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Components/service_card.dart';

class Privateteachingservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffB93434),
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Text(
            'Private Teaching',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/private_teaching2.png'),
                alignment: Alignment.centerRight,
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
              serviceName: 'Primary',
              imagePath: 'assets/images/private-teaching/primary.jpg',
            ),
            ServiceCard(
              serviceName: 'Preparatory',
              imagePath: 'assets/images/private-teaching/Preparatory.jpg',
            ),
            ServiceCard(
              serviceName: 'Secondary',
              imagePath: 'assets/images/private-teaching/secondary.jpg',
            ),
            ServiceCard(
              serviceName: 'Musical Instruments',
              imagePath:
              'assets/images/private-teaching/musical-instruments.jpg',
            ),
            ServiceCard(
              serviceName: 'Religion',
              imagePath: 'assets/images/private-teaching/Religion.jpg',
            ),
            ServiceCard(
              serviceName: 'Languages',
              imagePath: 'assets/images/private-teaching/Languages.jpg',
            ),
          ],
        ),
      ),
    );
  }
}