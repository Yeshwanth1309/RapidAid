import 'package:get/get.dart';

class ThemeProvider extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
