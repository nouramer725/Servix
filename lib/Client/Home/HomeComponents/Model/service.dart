import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:servix/Client/Service/Care/Care.dart';
import 'package:servix/Client/Service/Delivery/Delivery.dart';
import 'package:servix/Client/Service/Devices/Devices.dart';
import 'package:servix/Client/Service/Home_Service/Home-Service.dart';
import 'package:servix/Client/Service/Man/Man.dart';
import 'package:servix/Client/Service/Private_Teaching/Private-Teaching.dart';
import 'package:servix/Client/Service/Woman/Woman.dart';

import '../../../../Components/Description Screen component.dart';

class Service {
  final String title;
  final String image;
  final VoidCallback onTap;
  final List<SubService> subServices;

  const Service({
    required this.title,
    required this.image,
    required this.onTap,
    required this.subServices,
  });
}

class SubService {
  final String title;
  final String image;
  final VoidCallback onTap;

  const SubService(
      {required this.title, required this.image, required this.onTap});
}

List<Service> Allservices = [
  Service(
    title: 'Home Service'.tr(),
    image: 'assets/images/search/Home.png',
    onTap: () {
      HomeService();
    },
    subServices: [
      SubService(
          title: 'Cleaning'.tr(),
          image: 'assets/images/home-service/cleaning.jpg',
          onTap: () {
            const DescriptionnScreen(
              title: 'Cleaning', // Custom title
              imagePath:
                  'assets/images/home-service/cleaning.jpg', // Custom image
            );
          }),
      SubService(
          title: 'Carpentry'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Carpentry', // Custom title
              imagePath:
                  'assets/images/home-service/Carpentry.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Carpentry.jpg'),
      SubService(
          title: 'Electricity'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Electricity', // Custom title
              imagePath:
                  'assets/images/home-service/Electricity.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Electricity.jpg'),
      SubService(
          title: 'Plumbing'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Plumbing', // Custom title
              imagePath:
                  'assets/images/home-service/Plumbing.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Plumbing.jpg'),
      SubService(
          title: 'Kitchen Technician'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Kitchen Technician', // Custom title
              imagePath:
                  'assets/images/home-service/Kitchentechnician.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Kitchentechnician.jpg'),
      SubService(
          title: 'Painting'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Painting', // Custom title
              imagePath:
                  'assets/images/home-service/painting.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/painting.jpg'),
      SubService(
          title: 'Camera Technician'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Camera Technician', // Custom title
              imagePath:
                  'assets/images/home-service/camera.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/camera.jpg'),
      SubService(
          title: 'Landscaper'.tr(),
          onTap: () {
            const DescriptionnScreen(
              title: 'Gardener', // Custom title
              imagePath:
                  'assets/images/home-service/LandScaper.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/LandScaper.jpg'),
    ],
  ),
  Service(
    title: 'Private Teaching'.tr(),
    image: 'assets/images/search/teach.jpg',
    onTap: () {
      Privateteachingservice();
    },
    subServices: [
      SubService(
          title: 'Primary'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Primary",
                imagePath: "assets/images/private-teaching/primary.jpg");
          },
          image: 'assets/images/private-teaching/primary.jpg'),
      SubService(
          title: 'Preparatory'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Preparatory",
                imagePath: "assets/images/private-teaching/Preparatory.jpg");
          },
          image: 'assets/images/private-teaching/Preparatory.jpg'),
      SubService(
          title: 'Secondary'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Secondary",
                imagePath: "assets/images/private-teaching/secondary.jpg");
          },
          image: 'assets/images/private-teaching/secondary.jpg'),
      SubService(
          title: 'Musical Instrument'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Musical Instrument",
                imagePath:
                    "assets/images/private-teaching/musical_instruments.jpg");
          },
          image: 'assets/images/private-teaching/musical_instruments.jpg'),
      SubService(
          title: 'Religion'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Religion",
                imagePath: "assets/images/private-teaching/Religion.jpg");
          },
          image: 'assets/images/private-teaching/Religion.jpg'),
      SubService(
          title: 'Languages'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Languages",
                imagePath: "assets/images/private-teaching/Languages.jpg");
          },
          image: 'assets/images/private-teaching/Languages.jpg'),
    ],
  ),
  Service(
    title: 'For Men'.tr(),
    image: 'assets/images/search/Men.png',
    onTap: () {
      Manservice();
    },
    subServices: [
      SubService(
          title: 'Private Coach'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Private Coach",
                imagePath: "assets/images/men/Privatecoach-man.jpeg");
          },
          image: 'assets/images/men/Privatecoach-man.jpeg'),
      SubService(
          title: 'Shaving'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Shaving", imagePath: "assets/images/men/Shaving.jpg");
          },
          image: 'assets/images/men/Shaving.jpg'),
      SubService(
          title: 'Massage'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Massage",
                imagePath: "assets/images/men/massage-man.jpg");
          },
          image: 'assets/images/men/massage-man.jpg'),
      SubService(
          title: 'Tailoring'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Tailoring",
                imagePath: "assets/images/men/Tailoring-man.jpg");
          },
          image: 'assets/images/men/Tailoring-man.jpg'),
    ],
  ),
  Service(
    title: 'For Women'.tr(),
    image: 'assets/images/search/woman.jpg',
    onTap: () {
      Womenservice();
    },
    subServices: [
      SubService(
          title: 'Hair Styling'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Hair Styling",
                imagePath: "assets/images/woman/hair_styling.jpg");
          },
          image: 'assets/images/woman/hair_styling.jpg'),
      SubService(
          title: 'Pedicure',
          onTap: () {
            const DescriptionnScreen(
                title: "Pedicure",
                imagePath: "assets/images/woman/pedicure.jpg");
          },
          image: 'assets/images/woman/pedicure.jpg'),
      SubService(
          title: 'Tailoring'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Tailoring",
                imagePath: "assets/images/woman/tailoring-woman.jpg");
          },
          image: 'assets/images/woman/tailoring-woman.jpg'),
      SubService(
          title: 'Henna',
          onTap: () {
            const DescriptionnScreen(
                title: "Henna", imagePath: "assets/images/woman/henna.jpg");
          },
          image: 'assets/images/woman/henna.jpg'),
      SubService(
          title: 'Massage'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Massage",
                imagePath: "assets/images/woman/massage_women.jpg");
          },
          image: 'assets/images/woman/massage_women.jpg'),
      SubService(
          title: 'Makeup Artist'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Makeup Artist",
                imagePath: "assets/images/woman/Makeup.jpg");
          },
          image: 'assets/images/woman/Makeup.jpg'),
      SubService(
          title: 'Nails',
          onTap: () {
            const DescriptionnScreen(
                title: "Nails", imagePath: "assets/images/woman/nails.jpg");
          },
          image: 'assets/images/woman/nails.jpg'),
      SubService(
          title: 'Private Coach'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Private Coach",
                imagePath: "assets/images/woman/Privatecoach-woman.jpg");
          },
          image: 'assets/images/woman/Privatecoach-woman.jpg'),
    ],
  ),
  Service(
    title: 'Care Service'.tr(),
    image: 'assets/images/search/care.jpg',
    onTap: () {
      Careservice();
    },
    subServices: [
      SubService(
          title: 'Children Care'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Children Care",
                imagePath: "assets/images/care/children.jpg");
          },
          image: 'assets/images/care/children.jpg'),
      SubService(
          title: 'Elderly Care'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Elderly Care",
                imagePath: "assets/images/care/Elder.jpg");
          },
          image: 'assets/images/care/Elder.jpg'),
      SubService(
          title: 'Pet Care'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Pet Care", imagePath: "assets/images/care/pet.jpg");
          },
          image: 'assets/images/care/pet.jpg'),
      SubService(
          title: 'Nursing Care'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Nursing Care",
                imagePath: "assets/images/care/nursing.jpg");
          },
          image: 'assets/images/care/nursing.jpg'),
      SubService(
          title: 'Disabilities Care'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Disabilities Care",
                imagePath: "assets/images/care/disability.jpg");
          },
          image: 'assets/images/care/disability.jpg'),
    ],
  ),
  Service(
    title: 'Devices Service'.tr(),
    image: 'assets/images/search/Devices.png',
    onTap: () {
      DevicesMaintenaceService();
    },
    subServices: [
      SubService(
          title: 'Mobile'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Mobile", imagePath: "assets/images/devices/mobile.jpg");
          },
          image: 'assets/images/devices/mobile.jpg'),
      SubService(
          title: 'Computer'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Computer",
                imagePath: "assets/images/devices/computer.jpg");
          },
          image: 'assets/images/devices/computer.jpg'),
      SubService(
          title: 'Air Conditioning'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Air Conditioning",
                imagePath: "assets/images/devices/air.jpg");
          },
          image: 'assets/images/devices/air.jpg'),
      SubService(
          title: 'Fridge',
          onTap: () {
            const DescriptionnScreen(
                title: "Fridge", imagePath: "assets/images/devices/fridge.jpg");
          },
          image: 'assets/images/devices/fridge.jpg'),
      SubService(
          title: 'Washing Machine'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Washing Machine",
                imagePath: "assets/images/devices/Washing.jpg");
          },
          image: 'assets/images/devices/Washing.jpg'),
      SubService(
          title: 'Screens',
          onTap: () {
            const DescriptionnScreen(
                title: "Screens",
                imagePath: "assets/images/devices/screen.jpg");
          },
          image: 'assets/images/devices/screen.jpg'),
      SubService(
          title: 'Microwave'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Microwave",
                imagePath: "assets/images/devices/microwave.jpg");
          },
          image: 'assets/images/devices/microwave.jpg'),
      SubService(
          title: 'Stove'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Stove", imagePath: "assets/images/devices/stove.jpg");
          },
          image: 'assets/images/devices/stove.jpg'),
      SubService(
          title: 'Water Heater'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Water Heater",
                imagePath: "assets/images/devices/water_heater.jpg");
          },
          image: 'assets/images/devices/water_heater.jpg'),
      SubService(
          title: 'Fan'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Fan", imagePath: "assets/images/devices/fan.jpg");
          },
          image: 'assets/images/devices/fan.jpg'),
    ],
  ),
  Service(
    title: 'Delivery Service'.tr(),
    image: 'assets/images/search/Delivery.png',
    onTap: () {
      DeliveryServices();
    },
    subServices: [
      SubService(
          title: 'School Delivery'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "School Delivery",
                imagePath: "assets/images/delivery/school.jpg");
          },
          image: 'assets/images/delivery/school.jpg'),
      SubService(
          title: 'Spend'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Spend", imagePath: "assets/images/delivery/spend.jpg");
          },
          image: 'assets/images/delivery/spend.jpg'),
      SubService(
          title: 'Taxi'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Taxi", imagePath: "assets/images/delivery/Taxi.jpg");
          },
          image: 'assets/images/delivery/Taxi.jpg'),
      SubService(
          title: 'Bus'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Bus", imagePath: "assets/images/delivery/bus.jpg");
          },
          image: 'assets/images/delivery/bus.jpg'),
      SubService(
          title: 'Truck'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Truck", imagePath: "assets/images/delivery/truck.jpg");
          },
          image: 'assets/images/delivery/truck.jpg'),
      SubService(
          title: 'Scooter'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Scooter",
                imagePath: "assets/images/delivery/scooter.jpg");
          },
          image: 'assets/images/delivery/scooter.jpg'),
      SubService(
          title: 'Loader Truck'.tr(),
          onTap: () {
            const DescriptionnScreen(
                title: "Loader Truck",
                imagePath: "assets/images/delivery/loader.jpg");
          },
          image: 'assets/images/delivery/loader.jpg'),
    ],
  ),
];
