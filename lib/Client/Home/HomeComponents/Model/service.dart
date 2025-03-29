class Service {
  final String title;
  final String image;
  final List<SubService> subServices;

  const Service({
    required this.title,
    required this.image,
    required this.subServices,
  });
}

class SubService {
  final String title;
  final String image;

  const SubService({
    required this.title,
    required this.image,
  });
}

const Allservices = [
  Service(
    title: 'Home Service',
    image: 'assets/images/home/home-service.png',
    subServices: [
      SubService(title: 'Cleaning', image: 'assets/images/home-service/cleaning.jpg'),
      SubService(title: 'Carpentry', image: 'assets/images/home-service/Carpentry.jpg'),
      SubService(title: 'Electricity', image: 'assets/images/home-service/Electricity.jpg'),
      SubService(title: 'Plumbing', image: 'assets/images/home-service/Plumbing.jpg'),
      SubService(title: 'Kitchen Technician', image: 'assets/images/home-service/Kitchentechnician.jpg'),
      SubService(title: 'Painting', image: 'assets/images/home-service/painting.jpg'),
      SubService(title: 'Camera Technician', image: 'assets/images/home-service/camera.jpg'),
      SubService(title: 'Landscaper', image: 'assets/images/home-service/LandScaper.jpg'),
    ],
  ),
  Service(
    title: 'Private Teaching',
    image: 'assets/images/home/private_teaching3.png',
    subServices: [
      SubService(title: 'Primary', image: 'assets/images/private-teaching/primary.jpg'),
      SubService(title: 'Preparatory', image: 'assets/images/private-teaching/Preparatory.jpg'),
      SubService(title: 'Secondary', image: 'assets/images/private-teaching/secondary.jpg'),
      SubService(title: 'Musical Instrument', image: 'assets/images/private-teaching/musical_instrument.jpg'),
      SubService(title: 'Religion', image: 'assets/images/private-teaching/Religion.jpg'),
      SubService(title: 'Languages', image: 'assets/images/private-teaching/Languages.jpg'),
    ],
  ),
  Service(
    title: 'For Men',
    image: 'assets/images/home/man.png',
    subServices: [
      SubService(title: 'Private Coach', image: 'assets/images/men/Privatecoach-man.jpeg'),
      SubService(title: 'Shaving', image: 'assets/images/men/Shaving.jpg'),
      SubService(title: 'Massage', image: 'assets/images/men/massage.jpg'),
      SubService(title: 'Tailoring', image: 'assets/images/men/Tailoring.jpg'),
    ],
  ),
  Service(
    title: 'For Women',
    image: 'assets/images/home/woman.png',
    subServices: [
      SubService(title: 'Hair Styling', image: 'assets/images/woman/hair_styling.jpg'),
      SubService(title: 'Pedicure', image: 'assets/images/woman/pedicure.jpg'),
      SubService(title: 'Tailoring', image: 'assets/images/woman/tailoring_women.jpg'),
      SubService(title: 'Henna', image: 'assets/images/woman/henna.jpg'),
      SubService(title: 'Massage', image: 'assets/images/woman/massage_women.jpg'),
      SubService(title: 'Makeup Artist', image: 'assets/images/woman/Makeup.jpg'),
      SubService(title: 'Nails', image: 'assets/images/woman/nails.jpg'),
      SubService(title: 'Private Coach', image: 'assets/images/woman/Privatecoach-woman.jpg'),
    ],
  ),
  Service(
    title: 'Care Service',
    image: 'assets/images/home/care.png',
    subServices: [
      SubService(title: 'Children Care', image: 'assets/images/care/children.jpg'),
      SubService(title: 'Elderly Care', image: 'assets/images/care/Elder.jpg'),
      SubService(title: 'Pet Care', image: 'assets/images/care/pet.jpg'),
      SubService(title: 'Nursing Care', image: 'assets/images/care/nursing.jpg'),
      SubService(title: 'Disabilities Care', image: 'assets/images/care/disability.jpg'),
    ],
  ),
  Service(
    title: 'Devices Service',
    image: 'assets/images/home/devices.png',
    subServices: [
      SubService(title: 'Mobile', image: 'assets/images/devices/mobile.jpg'),
      SubService(title: 'Computer', image: 'assets/images/devices/computer.jpg'),
      SubService(title: 'Air Conditioning', image: 'assets/images/devices/air.jpg'),
      SubService(title: 'Fridge', image: 'assets/images/devices/fridge.jpg'),
      SubService(title: 'Washing Machine', image: 'assets/images/devices/Washing.jpg'),
      SubService(title: 'Screens', image: 'assets/images/devices/screen.jpg'),
      SubService(title: 'Microwave', image: 'assets/images/devices/microwave.jpg'),
      SubService(title: 'Stove', image: 'assets/images/devices/stove.jpg'),
      SubService(title: 'Water Heater', image: 'assets/images/devices/water_heater.jpg'),
      SubService(title: 'Fan', image: 'assets/images/devices/fan.jpg'),
    ],
  ),
  Service(
    title: 'Delivery Service',
    image: 'assets/images/home/delivery.png',
    subServices: [
      SubService(title: 'School Delivery', image: 'assets/images/delivery/school.jpg'),
      SubService(title: 'Spend', image: 'assets/images/delivery/spend.jpg'),
      SubService(title: 'Taxi', image: 'assets/images/delivery/Taxi.jpg'),
      SubService(title: 'Bus', image: 'assets/images/delivery/bus.jpg'),
      SubService(title: 'Truck', image: 'assets/images/delivery/truck.jpg'),
      SubService(title: 'Scooter', image: 'assets/images/delivery/scooter.jpg'),
      SubService(title: 'Loader Truck', image: 'assets/images/delivery/loader.jpg'),
    ],
  ),
];
