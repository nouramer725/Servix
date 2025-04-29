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
            DescriptionnScreen(
              title: 'Cleaning'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/cleaning.jpg', // Custom image
            );
          }),
      SubService(
          title: 'Carpentry'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Carpentry'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/Carpentry.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Carpentry.jpg'),
      SubService(
          title: 'Electricity'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Electricity'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/Electricity.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Electricity.jpg'),
      SubService(
          title: 'Plumbing'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Plumbing'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/Plumbing.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Plumbing.jpg'),
      SubService(
          title: 'Kitchen Technician'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Kitchen Technician'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/Kitchentechnician.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/Kitchentechnician.jpg'),
      SubService(
          title: 'Painting'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Painting'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/painting.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/painting.jpg'),
      SubService(
          title: 'Camera Technician'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Camera Technician'.tr(), // Custom title
              imagePath:
                  'assets/images/home-service/camera.jpg', // Custom image
            );
          },
          image: 'assets/images/home-service/camera.jpg'),
      SubService(
          title: 'Landscaper'.tr(),
          onTap: () {
            DescriptionnScreen(
              title: 'Gardener'.tr(), // Custom title
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
            DescriptionnScreen(
                title: "Primary".tr(),
                imagePath: "assets/images/private-teaching/primary.jpg");
          },
          image: 'assets/images/private-teaching/primary.jpg'),
      SubService(
          title: 'Preparatory'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Preparatory".tr(),
                imagePath: "assets/images/private-teaching/Preparatory.jpg");
          },
          image: 'assets/images/private-teaching/Preparatory.jpg'),
      SubService(
          title: 'Secondary'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Secondary".tr(),
                imagePath: "assets/images/private-teaching/secondary.jpg");
          },
          image: 'assets/images/private-teaching/secondary.jpg'),
      SubService(
          title: 'Musical Instrument'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Musical Instrument".tr(),
                imagePath:
                    "assets/images/private-teaching/musical_instruments.jpg");
          },
          image: 'assets/images/private-teaching/musical_instruments.jpg'),
      SubService(
          title: 'Religion'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Religion".tr(),
                imagePath: "assets/images/private-teaching/Religion.jpg");
          },
          image: 'assets/images/private-teaching/Religion.jpg'),
      SubService(
          title: 'Languages'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Languages".tr(),
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
            DescriptionnScreen(
                title: "Private Coach".tr(),
                imagePath: "assets/images/men/Privatecoach-man.jpeg");
          },
          image: 'assets/images/men/Privatecoach-man.jpeg'),
      SubService(
          title: 'Haircut'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Haircut".tr(),
                imagePath: "assets/images/men/Shaving.jpg");
          },
          image: 'assets/images/men/Shaving.jpg'),
      SubService(
          title: 'Massage Man'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Massage Man".tr(),
                imagePath: "assets/images/men/massage-man.jpg");
          },
          image: 'assets/images/men/massage-man.jpg'),
      SubService(
          title: 'Tailoring Man'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Tailoring Man".tr(),
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
            DescriptionnScreen(
                title: "Hair Styling".tr(),
                imagePath: "assets/images/woman/hair_styling.jpg");
          },
          image: 'assets/images/woman/hair_styling.jpg'),
      SubService(
          title: 'Pedicure',
          onTap: () {
            DescriptionnScreen(
                title: "Pedicure".tr(),
                imagePath: "assets/images/woman/pedicure.jpg");
          },
          image: 'assets/images/woman/pedicure.jpg'),
      SubService(
          title: 'Tailoring'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Tailoring".tr(),
                imagePath: "assets/images/woman/tailoring-woman.jpg");
          },
          image: 'assets/images/woman/tailoring-woman.jpg'),
      SubService(
          title: 'Henna',
          onTap: () {
            DescriptionnScreen(
                title: "Henna".tr(),
                imagePath: "assets/images/woman/henna.jpg");
          },
          image: 'assets/images/woman/henna.jpg'),
      SubService(
          title: 'Massage'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Massage".tr(),
                imagePath: "assets/images/woman/massage_women.jpg");
          },
          image: 'assets/images/woman/massage_women.jpg'),
      SubService(
          title: 'MakeUp Artist'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "MakeUp Artist".tr(),
                imagePath: "assets/images/woman/Makeup.jpg");
          },
          image: 'assets/images/woman/Makeup.jpg'),
      SubService(
          title: 'Nails'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Nails".tr(),
                imagePath: "assets/images/woman/nails.jpg");
          },
          image: 'assets/images/woman/nails.jpg'),
      SubService(
          title: 'Private Coach Woman'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Private Coach Woman".tr(),
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
          title: 'Children'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Children".tr(),
                imagePath: "assets/images/care/children.jpg");
          },
          image: 'assets/images/care/children.jpg'),
      SubService(
          title: 'Elderly'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Elderly".tr(),
                imagePath: "assets/images/care/Elder.jpg");
          },
          image: 'assets/images/care/Elder.jpg'),
      SubService(
          title: 'Pet'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Pet".tr(), imagePath: "assets/images/care/pet.jpg");
          },
          image: 'assets/images/care/pet.jpg'),
      SubService(
          title: 'Nursing'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Nursing".tr(),
                imagePath: "assets/images/care/nursing.jpg");
          },
          image: 'assets/images/care/nursing.jpg'),
      SubService(
          title: 'Disabilities'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Disabilities".tr(),
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
            DescriptionnScreen(
                title: "Mobile".tr(),
                imagePath: "assets/images/devices/mobile.jpg");
          },
          image: 'assets/images/devices/mobile.jpg'),
      SubService(
          title: 'Computer'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Computer".tr(),
                imagePath: "assets/images/devices/computer.jpg");
          },
          image: 'assets/images/devices/computer.jpg'),
      SubService(
          title: 'Air Conditioning'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Air Conditioning".tr(),
                imagePath: "assets/images/devices/air.jpg");
          },
          image: 'assets/images/devices/air.jpg'),
      SubService(
          title: 'Fridge',
          onTap: () {
            DescriptionnScreen(
                title: "Fridge".tr(),
                imagePath: "assets/images/devices/fridge.jpg");
          },
          image: 'assets/images/devices/fridge.jpg'),
      SubService(
          title: 'Washing Machine'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Washing Machine".tr(),
                imagePath: "assets/images/devices/Washing.jpg");
          },
          image: 'assets/images/devices/Washing.jpg'),
      SubService(
          title: 'Screens',
          onTap: () {
            DescriptionnScreen(
                title: "Screens".tr(),
                imagePath: "assets/images/devices/screen.jpg");
          },
          image: 'assets/images/devices/screen.jpg'),
      SubService(
          title: 'Microwave'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Microwave".tr(),
                imagePath: "assets/images/devices/microwave.jpg");
          },
          image: 'assets/images/devices/microwave.jpg'),
      SubService(
          title: 'Stove'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Stove".tr(),
                imagePath: "assets/images/devices/stove.jpg");
          },
          image: 'assets/images/devices/stove.jpg'),
      SubService(
          title: 'Water Heater'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Water Heater".tr(),
                imagePath: "assets/images/devices/water_heater.jpg");
          },
          image: 'assets/images/devices/water_heater.jpg'),
      SubService(
          title: 'Fan'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Fan".tr(), imagePath: "assets/images/devices/fan.jpg");
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
            DescriptionnScreen(
                title: "School Delivery".tr(),
                imagePath: "assets/images/delivery/school.jpg");
          },
          image: 'assets/images/delivery/school.jpg'),
      SubService(
          title: 'Parcels'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Parcels".tr(),
                imagePath: "assets/images/delivery/spend.jpg");
          },
          image: 'assets/images/delivery/spend.jpg'),
      SubService(
          title: 'Taxi'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Taxi".tr(),
                imagePath: "assets/images/delivery/Taxi.jpg");
          },
          image: 'assets/images/delivery/Taxi.jpg'),
      SubService(
          title: 'Bus'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Bus".tr(), imagePath: "assets/images/delivery/bus.jpg");
          },
          image: 'assets/images/delivery/bus.jpg'),
      SubService(
          title: 'Truck'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Truck".tr(),
                imagePath: "assets/images/delivery/truck.jpg");
          },
          image: 'assets/images/delivery/truck.jpg'),
      SubService(
          title: 'Scooter'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Scooter".tr(),
                imagePath: "assets/images/delivery/scooter.jpg");
          },
          image: 'assets/images/delivery/scooter.jpg'),
      SubService(
          title: 'Loader Truck'.tr(),
          onTap: () {
            DescriptionnScreen(
                title: "Loader Truck".tr(),
                imagePath: "assets/images/delivery/loader.jpg");
          },
          image: 'assets/images/delivery/loader.jpg'),
    ],
  ),
];
