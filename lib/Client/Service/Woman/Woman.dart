import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class Womenservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffC37B7B),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            'For Women',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/woman.png'),
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
              serviceName: 'Hair Styling',
              imagePath: 'assets/images/woman/hair-styling.jpg',
            ),
            ServiceCard(
              serviceName: 'henna',
              imagePath: 'assets/images/woman/henna.jpg',
            ),
            ServiceCard(
              serviceName: 'Tailoring',
              imagePath: 'assets/images/woman/tailoring-woman.jpg',
            ),
            ServiceCard(
              serviceName: 'Massage',
              imagePath: 'assets/images/woman/massage-woman.jpg',
            ),
            ServiceCard(
              serviceName: 'Private Coach',
              imagePath: 'assets/images/woman/Privatecoach-woman.jpg',
            ),
            ServiceCard(
              serviceName: 'Makeup Artist',
              imagePath: 'assets/images/woman/Makeup.jpg',
            ),
            ServiceCard(
              serviceName: 'Nails',
              imagePath: 'assets/images/woman/nails.jpg',
            ),
            ServiceCard(
              serviceName: 'Padicure',
              imagePath: 'assets/images/woman/padicure.jpg',
            ),
          ],
        ),
      ),
    );
  }
}