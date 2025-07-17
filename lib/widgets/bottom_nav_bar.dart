import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    const itemCount = 3;
    // ignore: unused_local_variable
    final itemWidth = MediaQuery.of(context).size.width / itemCount;

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: AppColors.white,
      selectedLabelStyle: const TextStyle(color: Colors.white),
      unselectedLabelStyle: const TextStyle(color: Colors.white),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primaryBlue,
      items: [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: widget.currentIndex == 0
                    ? 1.3
                    : 1.0, // Slightly larger scale (1.3)
                child: Icon(
                  FontAwesomeIcons.user,
                  color:
                      widget.currentIndex == 0 ? Colors.black : AppColors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(height: 5.0), // Keeps text below the enlarged icon
            ],
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: widget.currentIndex == 1
                    ? 1.3
                    : 1.0, // Slightly larger scale (1.3)
                child: Icon(
                  FontAwesomeIcons.exclamationCircle,
                  color:
                      widget.currentIndex == 1 ? Colors.black : AppColors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(height: 5.0), // Keeps text below the enlarged icon
            ],
          ),
          label: 'SOS',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: widget.currentIndex == 2
                    ? 1.3
                    : 1.0, // Slightly larger scale (1.3)
                child: Icon(
                  FontAwesomeIcons.phone,
                  color:
                      widget.currentIndex == 2 ? Colors.black : AppColors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(height: 5.0), // Keeps text below the enlarged icon
            ],
          ),
          label: 'Services',
        ),
      ],
    );
  }
}
