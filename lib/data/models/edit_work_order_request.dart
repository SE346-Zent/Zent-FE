class EditWorkOrderRequest {
  final String? address;
  final String? appointment;
  final String? building;
  final String? productId;
  final String? ward;

  EditWorkOrderRequest({
    this.address,
    this.appointment,
    this.building,
    this.productId,
    this.ward,
  });

  Map<String, dynamic> toJson() {
    return {
      if (address != null) 'address': address,
      if (appointment != null) 'appointment': appointment,
      if (building != null) 'building': building,
      if (productId != null) 'productId': productId,
      if (ward != null) 'ward': ward,
    };
  }
}
