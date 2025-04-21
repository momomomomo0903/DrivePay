import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final List<PopupMenuEntry<String>> menuItems;
  final Function(String) onMenuSelected;

  const GroupCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.menuItems,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFffffff),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xff45c4b0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xff45c4b0)),
                  onSelected: onMenuSelected,
                  itemBuilder: (BuildContext context) => menuItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 