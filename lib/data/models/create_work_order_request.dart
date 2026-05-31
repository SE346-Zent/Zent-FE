class CreateWorkOrderRequest {
  final String address;
  final String appointment;
  final String? building;
  final String city;
  final String country;
  final String description;
  final String? email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String productId;
  final String? referenceTicketId;
  final String ward;
  final int workOrderSymptomId;

  CreateWorkOrderRequest({
    required this.address,
    required this.appointment,
    this.building,
    required this.city,
    required this.country,
    required this.description,
    this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.productId,
    this.referenceTicketId,
    required this.ward,
    required this.workOrderSymptomId,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'appointment': appointment,
      'building': building,
      'city': city,
      'country': country,
      'description': description,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'product_id': productId,
      'reference_ticket_id': referenceTicketId,
      'ward': ward,
      'work_order_symptom_id': workOrderSymptomId,
    };
  }
}
