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
              serviceName: 'Haircut'.tr(),
              imagePath: 'assets/images/men/Shaving.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                        title: "Haircut",
                        imagePath: "assets/images/men/Shaving.jpg"),
                  ),
                );
              },
            ),
            ServiceCard(
                serviceName: 'Tailoring'.tr(),
                imagePath: 'assets/images/men/Tailoring-man.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                          title: "Tailoring",
                          imagePath: "assets/images/men/Tailoring-man.jpg"),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Massage'.tr(),
                imagePath: 'assets/images/men/massage-man.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                          title: "Massage",
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
                      builder: (context) => const DescriptionnScreen(
                        title: "Private Coach",
                        imagePath: "assets/images/men/Privatecoach-man.jpeg",
                      ),
                    ),
                  );
                }),
            // ServiceCard(
            //   serviceName: 'Haircut'.tr(),
            //   imagePath: 'assets/images/men/haircut.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Grooming'.tr(),
            //   imagePath: 'assets/images/men/grooming.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Shower'.tr(),
            //   imagePath: 'assets/images/men/shower.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Personal Shopper'.tr(),
            //   imagePath: 'assets/images/men/personal-shopper.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Yoga Instructor'.tr(),
            //   imagePath: 'assets/images/men/yoga.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Personal Chef'.tr(),
            //   imagePath: 'assets/images/men/personal-chef.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Fitness Trainer'.tr(),
            //   imagePath: 'assets/images/men/fitness-trainer.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Boxing Coach'.tr(),
            //   imagePath: 'assets/images/men/boxing-coach.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Nutritionist'.tr(),
            //   imagePath: 'assets/images/men/nutritionist.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Shoe Cleaning'.tr(),
            //   imagePath: 'assets/images/men/shoe-cleaning.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Fashion Consultant'.tr(),
            //   imagePath: 'assets/images/men/fashion-consultant.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
