import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../components/cards/service_card.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.servicesTitle,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            ServiceCard(
              title: 'Police',
              icon: FontAwesomeIcons.shieldHalved,
              iconColor: AppColors.policeBlue,
              onTap: () {
                Get.to(() => const ServiceDetailScreen(
                      service: 'Police',
                      helpline: '100',
                      locationLatitude: 17.7385, // Narsapur coordinates
                      locationLongitude: 78.2785,
                    ));
                Get.snackbar('Accessing', 'Police Services...',
                    snackPosition: SnackPosition.TOP);
              },
            ),
            ServiceCard(
              title: 'Fire Brigade',
              icon: FontAwesomeIcons.fire,
              iconColor: AppColors.fireOrange,
              onTap: () {
                Get.to(() => const ServiceDetailScreen(
                      service: 'Fire Brigade',
                      helpline: '101',
                      locationLatitude: 17.7385, // Narsapur coordinates
                      locationLongitude: 78.2785,
                    ));
                Get.snackbar('Accessing', 'Fire Brigade Services...',
                    snackPosition: SnackPosition.TOP);
              },
            ),
            ServiceCard(
              title: 'Hospitals',
              icon: FontAwesomeIcons.hospital,
              iconColor: AppColors.hospitalGreen,
              onTap: () {
                Get.to(() => const ServiceDetailScreen(
                      service: 'Hospitals',
                      helpline: '108',
                      locationLatitude: 17.7385, // Narsapur coordinates
                      locationLongitude: 78.2785,
                    ));
                Get.snackbar('Accessing', 'Hospital Services...',
                    snackPosition: SnackPosition.TOP);
              },
            ),
            ServiceCard(
              title: 'Ambulance',
              icon: FontAwesomeIcons.ambulance,
              iconColor: AppColors.ambulanceRed,
              onTap: () {
                Get.to(() => const ServiceDetailScreen(
                      service: 'Ambulance',
                      helpline: '108',
                      locationLatitude: 17.7385, // Narsapur coordinates
                      locationLongitude: 78.2785,
                    ));
                Get.snackbar('Accessing', 'Ambulance Services...',
                    snackPosition: SnackPosition.TOP);
              },
            ),
          ],
        ),
      ),
    );
  }
}
