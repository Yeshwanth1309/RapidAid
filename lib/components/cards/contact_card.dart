import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ContactCard({
    super.key,
    required this.name,
    required this.phone,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.person, color: AppColors.primaryBlue),
        title: Text(name, style: const TextStyle(fontSize: 16)),
        subtitle: Text(phone, style: const TextStyle(fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
