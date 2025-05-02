import 'package:flutter/material.dart';

class GroupDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> groups;
  final String? selectedGroupId;
  final Function(String?) onChanged;

  const GroupDropdown({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("グループを選択"),
        DropdownButton<String>(
          value: selectedGroupId,
          items:
              groups.map((group) {
                return DropdownMenuItem<String>(
                  value: group['groupId'],
                  child: Text(group['groupName'] ?? '名前なし'),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
