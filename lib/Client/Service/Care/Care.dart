import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class Careservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffF7C86E),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Care Service'.tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/home/care.png'),
                alignment: context.locale.languageCode == 'ar'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
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
              serviceName: 'Elderly'.tr(),
              imagePath: 'assets/images/care/Elder.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                      title: 'Elderly'.tr(),
                      imagePath: 'assets/images/care/Elder.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Children'.tr(),
              imagePath: 'assets/images/care/children.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                      title: 'Children'.tr(), // Custom title
                      imagePath:
                          'assets/images/care/children.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Nursing'.tr(),
              imagePath: 'assets/images/care/nursing.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                      title: 'Nursing'.tr(), // Custom title
                      imagePath:
                          'assets/images/care/nursing.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Pet'.tr(),
              imagePath: 'assets/images/care/pet.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                      title: 'Pet'.tr(), // Custom title
                      imagePath: 'assets/images/care/pet.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Disabilities'.tr(),
              imagePath: 'assets/images/care/disability.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                      title: 'Disabilities'.tr(), // Custom title
                      imagePath:
                          'assets/images/care/disability.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
