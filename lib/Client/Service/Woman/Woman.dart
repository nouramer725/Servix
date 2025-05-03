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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/home/woman.png'),
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
              serviceName: 'Hair Styling'.tr(),
              imagePath: 'assets/images/woman/hair-styling.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                        title: "Hair Styling".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Henna".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Tailoring".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Massage".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Private Coach Woman".tr(),
                        imagePath:
                            "assets/images/woman/Privatecoach-woman.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'MakeUp Artist'.tr(),
              imagePath: 'assets/images/woman/Makeup.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                        title: "MakeUp Artist".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Nails".tr(),
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
                    builder: (context) => DescriptionnScreen(
                        title: "Pedicure".tr(),
                        imagePath: "assets/images/woman/padicure.jpg"),
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
