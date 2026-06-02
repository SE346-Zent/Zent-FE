class RegisterProductResult {
  final String productId;
  final String serialNumber;
  final String message;
  final bool emailSent;

  RegisterProductResult({
    required this.productId,
    required this.serialNumber,
    required this.message,
    required this.emailSent,
  });
}
