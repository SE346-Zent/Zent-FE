extension WorkOrderIdExtension on String {
  String get toShortWorkOrderId {
    if (isEmpty) return this;
    final cleanId = replaceAll('#', '').replaceAll('WO-', '').toUpperCase();
    if (cleanId.length > 4) {
      return '#WO-${cleanId.substring(0, 4)}';
    }
    return '#WO-$cleanId';
  }
}
