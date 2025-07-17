import '../models/location.dart';

class LocationService {
  Future<Location> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    return Location(latitude: 28.6139, longitude: 77.2090); // Delhi
  }
}
