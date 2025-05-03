class OrderModelTech {
  final String ServiceType;
  final String Description;
  final String Date;
  final String Time;
  final String? FName;
  final String? LName;
  final String? image;
  final String Location;
  final String ServiceImage;
  final String apartment;
  final String building;
  final String street;
  final String? userId;
  final String? docPath;
  final String? previousOffer;
  final String Status;
  final List<String> fileUrls;

  const OrderModelTech(
      {required this.ServiceType,
      required this.Description,
      required this.Date,
      required this.Time,
      required this.Location,
      required this.ServiceImage,
      required this.apartment,
      required this.building,
      required this.street,
      required this.fileUrls,
      this.FName,
      this.LName,
      this.userId,
      this.docPath,
      this.previousOffer,
      required this.Status,
      this.image});
}
