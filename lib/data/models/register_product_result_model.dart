import 'package:zent_fe/domain/entities/register_product_result.dart';

class RegisterProductResultModel extends RegisterProductResult {
  RegisterProductResultModel({
    required super.productId,
    required super.serialNumber,
    required super.message,
    required super.emailSent,
  });

  factory RegisterProductResultModel.fromJson(Map<String, dynamic> json) {
    return RegisterProductResultModel(
      productId: json['productId'] as String,
      serialNumber: json['serialNumber'] as String,
      message: json['message'] as String,
      emailSent: json['emailSent'] as bool,
    );
  }
}
