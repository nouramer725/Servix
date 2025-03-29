import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class Manservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xff305D67),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            'For Men',
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/man.png'),
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
              serviceName: 'Shaving',
              imagePath: 'assets/images/men/Shaving.jpg',
            ),
            ServiceCard(
              serviceName: 'Tailoring',
              imagePath: 'assets/images/men/Tailoring-man.jpg',
            ),
            ServiceCard(
              serviceName: 'Massage',
              imagePath: 'assets/images/men/massage-man.jpg',
            ),
            ServiceCard(
              serviceName: 'Private Coach',
              imagePath: 'assets/images/men/Privatecoach-man.jpeg',
            ),
          ],
        ),
      ),
    );
  }
}