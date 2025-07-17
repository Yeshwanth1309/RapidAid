import 'package:twilio_flutter/twilio_flutter.dart';
import '../models/contact.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class TwilioService {
  static bool isTwilioEnabled = false; // Set to true to enable Twilio
  static late TwilioFlutter twilio;

  static Future<void> initializeTwilio() async {
    final String accountSid = dotenv.env['TWILIO_ACCOUNT_SID'] ?? '';
    final String authToken = dotenv.env['TWILIO_AUTH_TOKEN'] ?? ''; // Replace with your Twilio Auth Token
    twilio = TwilioFlutter(
      accountSid: accountSid,
      authToken: authToken,
      twilioNumber: '+12675926341', // Replace with your Twilio phone number, e.g., "+1234567890"
    );
  }

  static Future<void> sendDistressMessage(List<Contact> contacts,
      String message, double latitude, double longitude) async {
    final mapsUrl = 'https://maps.google.com/?q=$latitude,$longitude';
    final fullMessage =
        '$message Location: ($latitude, $longitude), Map: $mapsUrl';

    if (isTwilioEnabled) {
      for (Contact contact in contacts) {
        try {
          await twilio.sendSMS(
            toNumber: contact.phone, // Updated to match Contact model's field
            messageBody: fullMessage,
          );
          print('Distress message sent to ${contact.name} at ${contact.phone}');
        } catch (e) {
          print('Error sending to ${contact.name}: $e');
        }
      }
    } else {
      for (Contact contact in contacts) {
        print(
            'Twilio disabled: Would send SMS to ${contact.phone} with message: $fullMessage');
      }
    }
  }
}
