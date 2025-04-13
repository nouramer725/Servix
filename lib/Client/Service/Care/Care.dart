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
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ServiceCard(
              serviceName: 'Elder'.tr(),
              imagePath: 'assets/images/care/Elder.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                      title: 'Elder Care',
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
                    builder: (context) => const DescriptionnScreen(
                      title: 'Children Care', // Custom title
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
                    builder: (context) => const DescriptionnScreen(
                      title: 'Nursing Care', // Custom title
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
                    builder: (context) => const DescriptionnScreen(
                      title: 'Pet Care', // Custom title
                      imagePath: 'assets/images/care/pet.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            ServiceCard(
              serviceName: 'Disability'.tr(),
              imagePath: 'assets/images/care/disability.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DescriptionnScreen(
                      title: 'Disability Care', // Custom title
                      imagePath:
                          'assets/images/care/disability.jpg', // Custom image
                    ),
                  ),
                );
              },
            ),
            // ServiceCard(
            //   serviceName: 'Mental Health'.tr(),
            //   imagePath: 'assets/images/care/mental_health.jpg',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const DescriptionnScreen(
            //           title: 'Children Care', // Custom title
            //           imagePath:
            //               'assets/images/care/children.jpg', // Custom image
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ServiceCard(
            //   serviceName: 'Hospice'.tr(),
            //   imagePath: 'assets/images/care/hospice.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Physiotherapy'.tr(),
            //   imagePath: 'assets/images/care/physiotherapy.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Speech Therapy'.tr(),
            //   imagePath: 'assets/images/care/speech_therapy.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Home Health Care'.tr(),
            //   imagePath: 'assets/images/care/home_health.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Pregnancy Care'.tr(),
            //   imagePath: 'assets/images/care/pregnancy_care.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Post Surgery Care'.tr(),
            //   imagePath: 'assets/images/care/post_surgery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Infant Care'.tr(),
            //   imagePath: 'assets/images/care/infant_care.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Disabled Children'.tr(),
            //   imagePath: 'assets/images/care/disabled_children.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Rehabilitation Care'.tr(),
            //   imagePath: 'assets/images/care/rehabilitation.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Personal Care'.tr(),
            //   imagePath: 'assets/images/care/personal_care.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
