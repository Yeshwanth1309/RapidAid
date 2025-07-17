import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rapid_aid_app/screens/auth/login_screen.dart';
import 'package:rapid_aid_app/screens/home/home_screen.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxString _userName = ''.obs; // Removed default 'User'
  final RxString _userEmail = ''.obs; // Removed default 'user@example.com'
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isFirstInstall = true.obs;
  final RxBool _isDarkMode = false.obs;

  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isFirstInstall => _isFirstInstall.value;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      _userEmail.value = user.email ?? '';
      _isLoggedIn.value = true;
      // Fetch userName from Firestore if stored (to be implemented in Step 5)
    }
    // Load isDarkMode and isFirstInstall from Firestore (to be implemented in Step 5)
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userEmail.value = userCredential.user?.email ?? '';
      _userName.value = name; // Store the name from signup
      _isLoggedIn.value = true;
      Get.snackbar('Success', 'Registered as $email',
          snackPosition: SnackPosition.TOP);
      Get.off(() => const HomeScreen()); // Navigate to HomeScreen on success
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userEmail.value = userCredential.user?.email ?? '';
      _isLoggedIn.value = true;
      _loadUserData();
      Get.snackbar('Success', 'Logged in as $email',
          snackPosition: SnackPosition.TOP);
      Get.off(() => const HomeScreen()); // Navigate to HomeScreen on success
    } catch (e) {
      Get.snackbar('Error', 'Sign in failed: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        Get.snackbar('Success', 'Verification sent to $email',
            snackPosition: SnackPosition.TOP);
      } catch (e) {
        Get.snackbar('Error', 'Failed to send reset email: $e',
            snackPosition: SnackPosition.TOP);
      }
    } else {
      Get.snackbar('Error', 'Please enter email',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _isLoggedIn.value = false;
    _userEmail.value = '';
    _userName.value = '';
    Get.snackbar('Success', 'Logged out', snackPosition: SnackPosition.TOP);
    Get.offAll(() => const LoginScreen()); // Navigate to LoginScreen on logout
  }

  void toggleDarkMode(bool value) {
    _isDarkMode.value = value;
    // Save to Firestore (to be implemented in Step 5)
  }

  void completeIntro() {
    _isFirstInstall.value = false;
    // Save to Firestore (to be implemented in Step 5)
  }

  Future<void> updateProfile(String name, String email) async {
    _userName.value = name;
    _userEmail.value = email;
    // Save to Firestore (to be implemented in Step 5)
    // Remove SharedPreferences logic for now
  }
}
