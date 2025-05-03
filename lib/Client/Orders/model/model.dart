class OrderModel {
  final String ServiceType;
  final String Description;
  final String Status;
  final String Date;
  final String Time;
  final String Location;
  final String apartment;
  final String building;
  final String street;
  final List<String> fileUrls;
  final String ProfileImage;
  final String Fname;
  final String Lname;
  final String ServiceImage;
  final String orderId;
  final String technicianName;
  final String technicianId;
  final String technicianImage;
  final String technicianLocationArea;
  final String technicianLocationStreet;
  final String technicianPhone;
  final String technicianSub;
  final String technicianMain;
  final String technicianDescription;
  final String technicianOffer;
  final String technicianLinkSocialMedia;

  const OrderModel({
    required this.ServiceType,
    required this.Description,
    required this.Status,
    required this.Date,
    required this.Time,
    required this.Fname,
    required this.Lname,
    required this.Location,
    required this.apartment,
    required this.building,
    required this.street,
    required this.fileUrls,
    required this.ServiceImage,
    required this.ProfileImage,
    required this.orderId,
    required this.technicianName,
    required this.technicianId,
    required this.technicianImage,
    required this.technicianLocationArea,
    required this.technicianLocationStreet,
    required this.technicianPhone,
    required this.technicianSub,
    required this.technicianMain,
    required this.technicianOffer,
    required this.technicianDescription,
    required this.technicianLinkSocialMedia,
  });
}
