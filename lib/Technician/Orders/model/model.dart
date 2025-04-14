class OrderModelTech {
  final String ServiceType;
  final String Description;
  final String Date;
  final String Time;
  final String? Name;
  final String? image;
  final String Location;


  const OrderModelTech({
    required this.ServiceType,
    required this.Description ,
    required this.Date,
    required this.Time,
    required this.Location,
    this.Name,
    this.image});
}