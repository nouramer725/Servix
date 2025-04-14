class OrderModel {
  final String ServiceType;
  final String Description;
  final String Status;
  final String Date;
  final String Time;
  final String? Name;
  final String? image;

  const OrderModel({
    required this.ServiceType,
    required this.Description ,
    required this.Status ,
    required this.Date,
    required this.Time,
    this.Name,
    this.image});
}