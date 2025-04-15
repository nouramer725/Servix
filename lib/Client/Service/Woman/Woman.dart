import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class Womenservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffC37B7B),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'For Women'.tr(),
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
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ServiceCard(
              serviceName: 'Hair Styling'.tr(),
              imagePath: 'assets/images/woman/hair-styling.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Hair Styling",
                        imagePath: "assets/images/woman/hair-styling.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Henna'.tr(),
              imagePath: 'assets/images/woman/henna.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Henna",
                        imagePath: "assets/images/woman/henna.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Tailoring'.tr(),
              imagePath: 'assets/images/woman/tailoring-woman.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Tailoring",
                        imagePath: "assets/images/woman/tailoring-woman.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Massage'.tr(),
              imagePath: 'assets/images/woman/massage-woman.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Massage",
                        imagePath: "assets/images/woman/massage-woman.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Private Coach Woman'.tr(),
              imagePath: 'assets/images/woman/Privatecoach-woman.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Private Coach Woman",
                        imagePath:
                            "assets/images/woman/Privatecoach-woman.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Makeup Artist'.tr(),
              imagePath: 'assets/images/woman/Makeup.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Makeup Artist",
                        imagePath: "assets/images/woman/Makeup.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Nails'.tr(),
              imagePath: 'assets/images/woman/nails.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Nails",
                        imagePath: "assets/images/woman/nails.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Pedicure'.tr(),
              imagePath: 'assets/images/woman/padicure.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Pedicure",
                        imagePath: "assets/images/woman/padicure.jpg"),
                  ),
                );
              },
            ),
            // ServiceCard(
            //   serviceName: 'Facial'.tr(),
            //   imagePath: 'assets/images/woman/facial.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Spa'.tr(),
            //   imagePath: 'assets/images/woman/spa.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Waxing'.tr(),
            //   imagePath: 'assets/images/woman/waxing.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Eyebrow Threading'.tr(),
            //   imagePath: 'assets/images/woman/eyebrow-threading.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Bridal Makeup'.tr(),
            //   imagePath: 'assets/images/woman/bridal-makeup.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Skincare'.tr(),
            //   imagePath: 'assets/images/woman/skincare.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Body Massage'.tr(),
            //   imagePath: 'assets/images/woman/body-massage.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Hair Treatment'.tr(),
            //   imagePath: 'assets/images/woman/hair-treatment.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
