import 'package:flutter/material.dart';

class ListModal extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData? itemIcon;
  final Color? itemIconColor;

  const ListModal({
    super.key,
    required this.title,
    required this.items,
    this.itemIcon,
    this.itemIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: items.map((item) => ListTile(
                title: Text(item),
                leading: Icon(
                  itemIcon ?? Icons.person,
                  color: itemIconColor,
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 