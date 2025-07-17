import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/buttons/action_button.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String service;
  final String helpline;
  final double locationLatitude;
  final double locationLongitude;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    required this.helpline,
    required this.locationLatitude,
    required this.locationLongitude,
  });

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Predefined Google Maps links near Narsapur, Telangana
  final Map<String, String> _serviceMapsLinks = {
    'Police':
        'https://www.google.com/maps/place/Narsapur+Police+Station/@17.7385,78.2785,15z',
    'Fire Brigade':
        'https://www.google.com/maps/place/Sangareddy+Fire+Station/@17.6185,78.0815,15z',
    'Hospitals':
        'https://www.google.com/maps/place/Government+Hospital+Narsapur/@17.7365,78.2805,15z',
    'Ambulance':
        'https://www.google.com/maps/search/ambulance+services/@17.7385,78.2785,15z',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to show the pop-up with the Google Maps link
  void _showLocationPopup() {
    final mapsLink = _serviceMapsLinks[widget.service] ?? '';
    if (mapsLink.isEmpty) {
      Get.snackbar('Error', 'Location not available for ${widget.service}',
          snackPosition: SnackPosition.TOP);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('${widget.service} Near Narsapur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tap the link to open in Google Maps:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(mapsLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar('Error', 'Could not open the link',
                      snackPosition: SnackPosition.TOP);
                }
              },
              child: Text(
                mapsLink,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.service} Options',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                text: '${widget.service} Location Near Me',
                onPressed: _showLocationPopup, // Trigger the pop-up
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: 'Call ${widget.service} Helpline',
                onPressed: () {
                  // Since we're avoiding backend, we'll simulate the call action
                  Get.snackbar('Calling',
                      'Dialing ${widget.helpline} for ${widget.service}...',
                      snackPosition: SnackPosition.TOP);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
