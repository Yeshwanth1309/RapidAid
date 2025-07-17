import 'package:get/get.dart';
import '../services/url_launcher_service.dart';

class ServiceProvider extends GetxController {
  final UrlLauncherService _urlLauncherService = UrlLauncherService();

  void callService(String service, String number) {
    _urlLauncherService.makePhoneCall(number);
    Get.snackbar('Calling', 'Calling $service ($number)...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void openLocation(String service, double latitude, double longitude) {
    if (service == 'Ambulance' || service == 'Fire Brigade') {
      Get.snackbar('Info', '$service comes to you',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      _urlLauncherService.openMap(latitude, longitude);
      Get.snackbar('Navigating', 'Opening $service location...',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
