import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/buttons/action_button.dart';
import '../../components/cards/contact_card.dart';
import '../../models/contact.dart';
import '../../providers/contact_provider.dart';
import '../../utils/validators.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = Get.find<ContactProvider>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    void showEditDialog(Contact contact) {
      final editNameController = TextEditingController(text: contact.name);
      final editPhoneController = TextEditingController(text: contact.phone);

      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: const InputDecoration(labelText: 'Contact Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: editPhoneController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (editNameController.text.isNotEmpty &&
                    Validators.isValidPhone(editPhoneController.text)) {
                  contactProvider.editContact(
                    contact,
                    Contact(
                      id: contact.id,
                      name: editNameController.text,
                      phone: editPhoneController.text,
                    ),
                  );
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Contact updated',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Invalid name or phone number',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }

    void showDeleteDialog(Contact contact) {
      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Delete Contact'),
          content: Text('Are you sure you want to delete ${contact.name}?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                contactProvider.removeContact(contact);
                Get.back(closeOverlays: true);
                Get.snackbar(
                  'Success',
                  'Contact deleted',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 2),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ActionButton(
              text: 'Add Contact',
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    Validators.isValidPhone(phoneController.text)) {
                  contactProvider.addContact(
                    Contact(
                      id: '',
                      name: nameController.text,
                      phone: phoneController.text,
                    ),
                  );
                  nameController.clear();
                  phoneController.clear();
                  Get.snackbar(
                    'Success',
                    'Contact added',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Invalid name or phone number',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: contactProvider.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contactProvider.contacts[index];
                    return ContactCard(
                      name: contact.name,
                      phone: contact.phone,
                      onDelete: () => showDeleteDialog(contact),
                      onEdit: () => showEditDialog(contact),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
