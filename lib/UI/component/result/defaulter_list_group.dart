import 'package:flutter/material.dart';

class NameItem {
  String name;
  bool isChecked;
  
  NameItem({required this.name, this.isChecked = false});
}

class DefaulterListGroup extends StatefulWidget {
  final int maxCount;
  
  const DefaulterListGroup({
    super.key,
    required this.maxCount,
  });

  @override
  State<DefaulterListGroup> createState() => _DefaulterListGroupState();
}

class _DefaulterListGroupState extends State<DefaulterListGroup> {
  final List<NameItem> _names = [
    NameItem(name: '山田太郎'),
    NameItem(name: '鈴木花子'),
    NameItem(name: '佐藤一郎'),
    NameItem(name: '田中次郎'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF45C4B0),
        border: Border(
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '滞納者リスト',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _names.asMap().entries.map((entry) {
                    final nameItem = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: nameItem.isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    nameItem.isChecked = value ?? false;
                                  });
                                },
                                activeColor: Colors.white,
                                checkColor: const Color(0xFF45C4B0),
                                side: const BorderSide(color: Colors.white),
                              ),
                              Text(
                                nameItem.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: nameItem.isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 