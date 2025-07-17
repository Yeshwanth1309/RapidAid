class SmsService {
  Future<void> sendSms(String phone, String message) async {
    await Future.delayed(const Duration(seconds: 1));
    print('SMS sent to $phone: $message');
  }
}
