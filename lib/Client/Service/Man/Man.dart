import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class Manservice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xff305D67),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'For Men'.tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/home/man.png'),
                alignment: context.locale.languageCode == 'ar'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
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
              serviceName: 'Haircut'.tr(),
              imagePath: 'assets/images/men/Shaving.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionnScreen(
                        title: "Haircut".tr(),
                        imagePath: "assets/images/men/Shaving.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
                serviceName: 'Tailoring Man'.tr(),
                imagePath: 'assets/images/men/Tailoring-man.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                          title: "Tailoring Man".tr(),
                          imagePath: "assets/images/men/Tailoring-man.jpg"),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Massage Man'.tr(),
                imagePath: 'assets/images/men/massage-man.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                          title: "Massage Man".tr(),
                          imagePath: "assets/images/men/massage-man.jpg"),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Private Coach'.tr(),
                imagePath: 'assets/images/men/Privatecoach-man.jpeg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: "Private Coach".tr(),
                        imagePath: "assets/images/men/Privatecoach-man.jpeg",
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
