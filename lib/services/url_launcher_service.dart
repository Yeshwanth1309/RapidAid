class UrlLauncherService {
  Future<void> makePhoneCall(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Mock call to $phoneNumber');
  }

  Future<void> openMap(double latitude, double longitude) async {
    print('Opening Google Maps at $latitude, $longitude');
  }
}
