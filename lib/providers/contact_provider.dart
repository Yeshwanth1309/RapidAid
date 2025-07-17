import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import '../models/location.dart';
import '../services/twilio_service.dart'; // Import TwilioService
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ContactProvider extends GetxController {
  final RxList<Contact> _contacts = <Contact>[].obs;
  final _uuid = const Uuid();
  final RxString _customSosMessage =
      'Help! I need assistance at this location.'.obs;

  List<Contact> get contacts => _contacts;
  String get customSosMessage => _customSosMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadContacts();
    _loadCustomSosMessage();
  }

  // Load contacts from SharedPreferences
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      final List<dynamic> decoded = jsonDecode(contactsJson);
      _contacts.assignAll(decoded.map((e) => Contact.fromJson(e)).toList());
    }
  }

  // Save contacts to SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(_contacts.map((e) => e.toJson()).toList());
    await prefs.setString('contacts', encoded);
  }

  // Load custom SOS message
  Future<void> _loadCustomSosMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? message = prefs.getString('customSosMessage');
    if (message != null) {
      _customSosMessage.value = message;
    }
  }

  // Save custom SOS message
  Future<void> _saveCustomSosMessage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customSosMessage', _customSosMessage.value);
  }

  void addContact(Contact contact) {
    // Prepend +91 if not already present and phone starts with a digit
    String formattedPhone = contact.phone.trim();
    if (formattedPhone.isNotEmpty &&
        !formattedPhone.startsWith('+') &&
        int.tryParse(formattedPhone[0]) != null) {
      formattedPhone = '+91$formattedPhone';
    }

    final newContact = Contact(
      id: _uuid.v4(),
      name: contact.name,
      phone: formattedPhone,
    );
    _contacts.add(newContact);
    print(
        'Added contact: ${newContact.name}, ${newContact.phone}, ID: ${newContact.id}');
    _saveContacts();
    _contacts.refresh();
  }

  void editContact(Contact oldContact, Contact newContact) {
    // Prepend +91 if not already present and phone starts with a digit
    String formattedPhone = newContact.phone.trim();
    if (formattedPhone.isNotEmpty &&
        !formattedPhone.startsWith('+') &&
        int.tryParse(formattedPhone[0]) != null) {
      formattedPhone = '+91$formattedPhone';
    }

    final index = _contacts.indexWhere((c) => c.id == oldContact.id);
    if (index != -1) {
      _contacts[index] = Contact(
        id: oldContact.id,
        name: newContact.name,
        phone: formattedPhone,
      );
      print(
          'Edited contact: ${newContact.name}, ${newContact.phone}, ID: ${oldContact.id}');
      _saveContacts();
      _contacts.refresh();
    }
  }

  void removeContact(Contact contact) {
    _contacts.removeWhere((c) => c.id == contact.id);
    print(
        'Removed contact: ${contact.name}, ${contact.phone}, ID: ${contact.id}');
    _saveContacts();
    _contacts.refresh();
  }

  void setCustomSosMessage(String message) {
    _customSosMessage.value = message;
    _saveCustomSosMessage();
    print('Set custom SOS message: $message');
  }

  Future<void> sendDistressMessage(Location location,
      {required bool isCritical}) async {
    if (_contacts.isEmpty) {
      Get.snackbar(
        'Warning',
        'No emergency contacts added',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      await TwilioService.sendDistressMessage(
        _contacts.toList(),
        "$_customSosMessage${isCritical ? ' (Critical)' : ''}",
        location.latitude,
        location.longitude,
      );

      if (!TwilioService.isTwilioEnabled) {
        Get.snackbar(
          'Success',
          'SMS sent to the contacts',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      // Success snackbar with contact names is handled in sos_screen.dart when Twilio is enabled
    } catch (e) {
      print('Error sending distress message: $e');
      Get.snackbar(
        'Error',
        'Failed to send distress message',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
