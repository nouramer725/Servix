import 'package:easy_localization/easy_localization.dart';

final Map<String, List<String>> subServicesMap = {
  "Home Service".tr(): [
    "Cleaning".tr(),
    "Carpentry".tr(),
    "Electricity".tr(),
    "Plumping".tr(),
    "Kitchen Technician".tr(),
    "Painting".tr(),
    "Camera Technician".tr(),
    "Gardener".tr()
  ],
  "Private Teaching".tr(): [
    "Primary".tr(),
    "Preparatory".tr(),
    "Secondary".tr(),
    "Musical Instrument".tr(),
    "Religion".tr(),
    "Languages".tr()
  ],
  "For Men".tr(): [
    "Private Coach".tr(),
    "Haircut".tr(),
    "Massage Man".tr(),
    "Tailoring Man".tr(),
  ],
  "For Women".tr(): [
    "Hair Styling".tr(),
    "Pedicure".tr(),
    "Tailoring".tr(),
    "Henna".tr(),
    "Massage".tr(),
    "MakeUp Artist".tr(),
    "Nails".tr(),
    "Private Coach Woman".tr()
  ],
  "Care Service".tr(): [
    "Children".tr(),
    "Elderly".tr(),
    "Pet".tr(),
    "Nursing".tr(),
    "Disabilities".tr()
  ],
  "Devices Service".tr(): [
    "Mobile".tr(),
    "Computer".tr(),
    "Air Conditioning".tr(),
    "Fridge".tr(),
    "Washing Machine".tr(),
    "Screens".tr(),
    "Microwave".tr(),
    "Stove".tr(),
    "Water Heater".tr(),
    "Fan".tr()
  ],
  "Delivery Service".tr(): [
    "School Delivery".tr(),
    "Parcels".tr(),
    "Taxi".tr(),
    "Bus".tr(),
    "Truck".tr(),
    "Scooter".tr(),
    "Loader Truck".tr(),
  ],
};

// Map<String, Map<String, String>> servicesMap = {
//   'private_teaching': {
//     'en': 'Private Teaching',
//     'ar': 'دروس خصوصية',
//   },
//   'musical_instruments': {
//     'en': 'Musical Instruments',
//     'ar': 'آلات موسيقية',
//   },
//   'Home_Service': {
//     'en': 'Home Service',
//     'ar': 'خدمات منزلية',
//   },
//   'cleaning': {
//     'en': 'Cleaning',
//     'ar': 'تنظيف',
//   },
//   'carpentry': {
//     'en': 'Carpentry',
//     'ar': 'نجارة',
//   },
//   'Electricity': {
//     'en': 'Electricity',
//     'ar': 'كهرباء',
//   },
//   'Plumbing': {
//     'en': 'Plumbing',
//     'ar': 'سباكة',
//   },
//   'Kitchen Technician': {
//     'en': 'Kitchen Technician',
//     'ar': 'فني مطبخ',
//   },
//   'Painting': {
//     'en': 'Painting',
//     'ar': 'دهان',
//   },
//   'Camera Technician': {
//     'en': 'Camera Technician',
//     'ar': 'فني كاميرات',
//   },
//   'Gardener': {
//     'en': 'Gardener',
//     'ar': 'جنايني',
//   },
//   'Primary': {
//     'en': 'Primary',
//     'ar': 'ابتدائي',
//   },
//   'Preparatory': {
//     'en': 'Preparatory',
//     'ar': 'إعدادي',
//   },
//   'Secondary': {
//     'en': 'Secondary',
//     'ar': 'ثانوي',
//   },
//   'Religion': {
//     'en': 'Religion',
//     'ar': 'ديني',
//   },
//   'Languages': {
//     'en': 'Language',
//     'ar': 'لغات',
//   },
//   'For Men': {
//     'en': 'For Men',
//     'ar': 'للرجال',
//   },
//   'Private Coach': {
//     'en': 'Private Coach',
//     'ar': 'مدرب خاص',
//   },
//   'Haircut': {
//     'en': 'Haircut',
//     'ar': 'حلاق',
//   },
//   'Massage Man': {
//     'en': 'Massage Man',
//     'ar': 'مساج',
//   },
//   'Tailoring Man': {
//     'en': 'Tailoring Man',
//     'ar': 'خياط',
//   },
//   'For Women': {
//     'en': 'For Women',
//     'ar': 'للنساء',
//   },
//   'Care Service': {
//     'en': 'Care Service',
//     'ar': 'خدمات الرعاية',
//   },
//   'Devices Service': {
//     'en': 'Devices Service',
//     'ar': 'صيانة الأجهزة',
//   },
//   'Delivery Service': {
//     'en': 'Delivery Service',
//     'ar': 'خدمات التوصيل',
//   },
//   'Hair Styling': {
//     'en': 'Hair Styling',
//     'ar': 'تصفيف الشعر',
//   },
//   'Pedicure': {
//     'en': 'Pedicure',
//     'ar': 'باديكير',
//   },
//   'Tailoring': {
//     'en': 'Tailoring',
//     'ar': 'خياطة',
//   },
//   'Henna': {
//     'en': 'Henna',
//     'ar': 'حناء',
//   },
//   'Massage': {
//     'en': 'Massage',
//     'ar': 'مساج',
//   },
//   'MakeUp Artist': {
//     'en': 'Makeup Artist',
//     'ar': 'أخصائية تجميل',
//   },
//   'Nails': {
//     'en': 'Nail',
//     'ar': 'أظافر',
//   },
//   'Private Coach Woman': {
//     'en': 'Private Coach Women',
//     'ar': 'مدربة خاصة',
//   },
//   'Children': {
//     'en': 'Children',
//     'ar': 'رعاية الأطفال',
//   },
//   'Elderly': {
//     'en': 'Elderly',
//     'ar': 'رعاية المسنين',
//   },
//   'Pet': {
//     'en': 'Pet',
//     'ar': 'رعاية الحيوانات الأليفة',
//   },
//   'Nursing': {
//     'en': 'Nursing',
//     'ar': 'تمريض',
//   },
//   'Disabilities': {
//     'en': 'Disabilities',
//     'ar': 'رعاية ذوي الاحتياجات الخاصة',
//   },
//   'Mobile': {
//     'en': 'Mobile',
//     'ar': 'موبايل',
//   },
//   'Computer': {
//     'en': 'Computer',
//     'ar': 'كمبيوتر',
//   },
//   'Air Conditioning': {
//     'en': 'Air Conditioning',
//     'ar': 'تكييف',
//   },
//   'Fridge': {
//     'en': 'Fridge',
//     'ar': 'ثلاجة',
//   },
//   'Washing Machine': {
//     'en': 'Washing Machine',
//     'ar': 'غسالة',
//   },
//   'Screens': {
//     'en': 'Screens',
//     'ar': 'شاشات',
//   },
//   'Microwave': {
//     'en': 'Microwave',
//     'ar': 'ميكروويف',
//   },
//   'Stove': {
//     'en': 'Stove',
//     'ar': 'بوتجاز',
//   },
//   'Water Heater': {
//     'en': 'Water Heater',
//     'ar': 'سخان مياه',
//   },
//   'Fan': {
//     'en': 'Fan',
//     'ar': 'مروحة',
//   },
//   'School Delivery': {
//     'en': 'School Delivery',
//     'ar': 'توصيل للمدارس',
//   },
//   'Parcels': {
//     'en': 'Parcels',
//     'ar': 'طرود',
//   },
//   'Taxi': {
//     'en': 'Taxi',
//     'ar': 'تاكسي',
//   },
//   'Bus': {
//     'en': 'Bus',
//     'ar': 'حافلة',
//   },
//   'Truck': {
//     'en': 'Truck',
//     'ar': 'شاحنة',
//   },
//   'Scooter': {
//     'en': 'Scooter',
//     'ar': 'سكوتر',
//   },
//   'Loader Truck': {
//     'en': 'Loader Truck',
//     'ar': 'شاحنة نقل',
//   },
// };
