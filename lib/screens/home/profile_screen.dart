import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/contact_provider.dart';
// import '../../screens/auth/login_screen.dart';
import '../../screens/settings/contacts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Get.find<AuthProvider>();
    final contactProvider = Get.find<ContactProvider>();
    final sosMessageController =
        TextEditingController(text: contactProvider.customSosMessage);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              // User Info Section
              InkWell(
                onTap: () {
                  final nameController = TextEditingController(
                      text: authProvider.userName.isEmpty
                          ? ''
                          : authProvider.userName); // Removed default 'User'
                  final emailController = TextEditingController(
                      text: authProvider.userEmail.isEmpty
                          ? ''
                          : authProvider
                              .userEmail); // Removed default 'user@example.com'

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text('Edit Profile'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final name = nameController.text.trim();
                            final email = emailController.text.trim();
                            final emailRegExp = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                            if (name.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Name cannot be empty',
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (!emailRegExp.hasMatch(email)) {
                              Get.snackbar(
                                'Error',
                                'Invalid email format',
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            authProvider.updateProfile(name, email);
                            Navigator.pop(context);
                            Get.snackbar(
                              'Success',
                              'Profile updated',
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          authProvider.userName.isEmpty
                              ? '?'
                              : authProvider.userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userName.isEmpty
                                ? 'Not Set'
                                : authProvider.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                          ),
                          Text(
                            authProvider.userEmail.isEmpty
                                ? 'Not Set'
                                : authProvider.userEmail,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              // Theme Toggle
              InkWell(
                onTap: () {
                  authProvider.toggleDarkMode(!authProvider.isDarkMode);
                },
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: Icon(
                    authProvider.isDarkMode
                        ? FontAwesomeIcons.moon
                        : FontAwesomeIcons.sun,
                    color: AppColors.primaryBlue,
                  ),
                  title: Text(
                    'Theme: ${authProvider.isDarkMode ? 'Dark' : 'Light'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              // Manage Emergency Contacts
              InkWell(
                onTap: () {
                  Get.to(() => const ContactsScreen());
                },
                borderRadius: BorderRadius.circular(12),
                child: const ListTile(
                  leading: Icon(
                    FontAwesomeIcons.addressBook,
                    color: AppColors.primaryBlue,
                  ),
                  title: Text(
                    'Manage Emergency Contacts',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Custom SOS Message
              InkWell(
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.message,
                    color: AppColors.primaryBlue,
                  ),
                  title: const Text(
                    'Custom SOS Message',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: sosMessageController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter SOS Message',
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final value = sosMessageController.text;
                            if (value.isNotEmpty) {
                              contactProvider.setCustomSosMessage(value);
                              Get.snackbar(
                                'Success',
                                'SOS message updated',
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Message cannot be empty',
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          },
                          child: const Text('Enter'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Logout
              InkWell(
                onTap: () {
                  authProvider.signOut();
                },
                borderRadius: BorderRadius.circular(12),
                child: const ListTile(
                  leading: Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: AppColors.primaryBlue,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
