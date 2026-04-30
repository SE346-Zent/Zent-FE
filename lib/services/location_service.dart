class Location {
  final double latitude;
  final double longitude;
  final double accuracy;

  Location({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}

class LocationRequest {
  // Can contain properties like interval, priority
}

abstract class LocationCallback {
  void onLocationResult(Location location);
  void onLocationError(Exception exception);
}

abstract class FusedLocationProviderClient {
  Future<void> requestLocationUpdates(
      LocationRequest request, LocationCallback callback);
  Future<void> removeLocationUpdates(LocationCallback callback);
}

class Geofence {
  final double latitude;
  final double longitude;
  final double radius;
  final String id;

  Geofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}

abstract class GeofencingClient {
  Future<void> addGeofences(List<Geofence> geofences);
  Future<void> removeGeofences(List<String> geofenceIds);
}

class InaccurateLocationException implements Exception {
  final String message;
  InaccurateLocationException(this.message);

  @override
  String toString() => 'InaccurateLocationException: $message';
}

class LocationService {
  final FusedLocationProviderClient _locationClient;
  final GeofencingClient _geofencingClient;

  LocationService(this._locationClient, this._geofencingClient);

  void startLocationUpdates(LocationRequest request, LocationCallback callback) {
    // We wrap the callback to enforce the GPS Accuracy Rule
    final wrappedCallback = _AccuracyCheckingCallback(callback);
    _locationClient.requestLocationUpdates(request, wrappedCallback);
  }

  Future<void> setupCheckInGeofence({
    required String id,
    required double latitude,
    required double longitude,
  }) async {
    // Geofencing Rule: strictly 300 meters
    final geofence = Geofence(
      id: id,
      latitude: latitude,
      longitude: longitude,
      radius: 300.0,
    );
    await _geofencingClient.addGeofences([geofence]);
  }
}

class _AccuracyCheckingCallback implements LocationCallback {
  final LocationCallback originalCallback;

  _AccuracyCheckingCallback(this.originalCallback);

  @override
  void onLocationResult(Location location) {
    if (location.accuracy > 100) {
      originalCallback.onLocationError(InaccurateLocationException(
          'Accuracy greater than 100 meters is unreliable.'));
    } else {
      originalCallback.onLocationResult(location);
    }
  }

  @override
  void onLocationError(Exception exception) {
    originalCallback.onLocationError(exception);
  }
}
