import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'sos_screen.dart';
import 'services_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 1); // Start at SOS
  final _currentIndex = 1.obs; // Sync with bottom nav bar (1 = SOS)

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _currentIndex.value = index; // Sync nav bar with swipe
        },
        children: const [
          ProfileScreen(),
          SOSScreeen(),
          ServicesScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: _currentIndex.value,
          onTap: (index) {
            _currentIndex.value = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }
}
