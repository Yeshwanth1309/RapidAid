import 'package:get/get.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class LocationProvider extends GetxController {
  var currentLocation = Rxn<Location>();

  final LocationService _locationService = LocationService();

  Future<void> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    currentLocation.value = location;
  }
}
