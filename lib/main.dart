import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_env.dart'; // Instead of firebase_options.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/contact_provider.dart';
import 'providers/location_provider.dart';
import 'providers/service_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/intro_screen.dart';
import 'services/twilio_service.dart'; // Twilio service that uses dotenv

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with values from .env
  await Firebase.initializeApp(
    options: getFirebaseOptions(),
  );

  // Initialize Twilio using values from .env
  await TwilioService.initializeTwilio();

  // Register providers
  Get.put(AuthProvider());
  Get.put(ContactProvider());
  Get.put(LocationProvider());
  Get.put(ServiceProvider());

  // Launch the app
  runApp(const RapidAidApp());
}

class RapidAidApp extends StatelessWidget {
  const RapidAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Rapid Aid',
        theme: Get.find<AuthProvider>().isDarkMode ? darkTheme : lightTheme,
        home: Get.find<AuthProvider>().isFirstInstall
            ? const IntroScreen()
            : const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
