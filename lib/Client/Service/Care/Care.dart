import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class Careservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffF7C86E),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            'Care Service',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/care.png'),
                alignment: Alignment.centerRight,
                //fit: BoxFit.cover,
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
              serviceName: 'Elder',
              imagePath: 'assets/images/care/Elder.jpg',
            ),
            ServiceCard(
              serviceName: 'Children',
              imagePath: 'assets/images/care/children.jpg',
            ),
            ServiceCard(
              serviceName: 'Nursing',
              imagePath: 'assets/images/care/nursing.jpg',
            ),
            ServiceCard(
              serviceName: 'Pet',
              imagePath: 'assets/images/care/pet.jpg',
            ),
            ServiceCard(
              serviceName: 'Disability',
              imagePath: 'assets/images/care/disability.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
