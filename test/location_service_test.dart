import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:zent_fe/services/location_service.dart';

import 'location_service_test.mocks.dart';

@GenerateMocks([FusedLocationProviderClient, GeofencingClient, LocationCallback])
void main() {
  late MockFusedLocationProviderClient mockLocationClient;
  late MockGeofencingClient mockGeofencingClient;
  late MockLocationCallback mockCallback;
  late LocationService locationService;

  setUp(() {
    mockLocationClient = MockFusedLocationProviderClient();
    mockGeofencingClient = MockGeofencingClient();
    mockCallback = MockLocationCallback();
    locationService = LocationService(mockLocationClient, mockGeofencingClient);
  });

  group('LocationService Tests', () {
    test('startLocationUpdates requests location updates via client', () {
      final request = LocationRequest();
      
      when(mockLocationClient.requestLocationUpdates(any, any))
          .thenAnswer((_) async => {});
          
      locationService.startLocationUpdates(request, mockCallback);
      
      verify(mockLocationClient.requestLocationUpdates(request, any)).called(1);
    });

    test('onLocationResult forwards location if accuracy <= 100', () {
      final request = LocationRequest();
      
      when(mockLocationClient.requestLocationUpdates(any, any))
          .thenAnswer((_) async => {});
          
      locationService.startLocationUpdates(request, mockCallback);

      // Capture the wrapped callback passed to the client
      final captured = verify(mockLocationClient.requestLocationUpdates(request, captureAny)).captured;
      final wrappedCallback = captured.single as LocationCallback;

      // Simulate a good location
      final goodLocation = Location(latitude: 10.0, longitude: 20.0, accuracy: 50.0);
      wrappedCallback.onLocationResult(goodLocation);

      // Verify the original callback received it
      verify(mockCallback.onLocationResult(goodLocation)).called(1);
      verifyNever(mockCallback.onLocationError(any));
    });

    test('onLocationResult returns error flag if accuracy > 100', () {
      final request = LocationRequest();
      
      when(mockLocationClient.requestLocationUpdates(any, any))
          .thenAnswer((_) async => {});
          
      locationService.startLocationUpdates(request, mockCallback);

      // Capture the wrapped callback passed to the client
      final captured = verify(mockLocationClient.requestLocationUpdates(request, captureAny)).captured;
      final wrappedCallback = captured.single as LocationCallback;

      // Simulate a bad location
      final badLocation = Location(latitude: 10.0, longitude: 20.0, accuracy: 150.0);
      wrappedCallback.onLocationResult(badLocation);

      // Verify the original callback got an error instead of the location
      verifyNever(mockCallback.onLocationResult(any));
      verify(mockCallback.onLocationError(argThat(isA<InaccurateLocationException>()))).called(1);
    });

    test('setupCheckInGeofence creates a geofence with exactly 300m radius', () async {
      when(mockGeofencingClient.addGeofences(any)).thenAnswer((_) async => {});

      await locationService.setupCheckInGeofence(
        id: 'test_fence',
        latitude: 10.0,
        longitude: 20.0,
      );

      final captured = verify(mockGeofencingClient.addGeofences(captureAny)).captured;
      final geofences = captured.single as List<Geofence>;
      
      expect(geofences.length, 1);
      expect(geofences.first.id, 'test_fence');
      expect(geofences.first.latitude, 10.0);
      expect(geofences.first.longitude, 20.0);
      expect(geofences.first.radius, 300.0);
    });
  });
}
