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
    return Container(
      width: 210,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF439A8C), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedGroupId,
          hint: const Text("選択してください"),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                child: Text("選択しない"),
              ),
            ),
            ...groups.map((group) {
              return DropdownMenuItem<String>(
                value: group['groupId'],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(group['groupName'] ?? '名前なし'),
                ),
              );
            }).toList(),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
