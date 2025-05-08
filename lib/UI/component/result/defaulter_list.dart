import 'package:flutter/material.dart';
import '../checkbox.dart';

class NameItem {
  String name;
  bool isChecked;
  
  NameItem({required this.name, this.isChecked = false});
}

class DefaulterList extends StatefulWidget {
  final int maxCount;
  
  const DefaulterList({
    super.key,
    required this.maxCount,
  });

  @override
  State<DefaulterList> createState() => _DefaulterListState();
}

class _DefaulterListState extends State<DefaulterList> {
  final TextEditingController _nameController = TextEditingController();
  final List<NameItem> _names = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addName() {
    if (_nameController.text.isNotEmpty && _names.length < widget.maxCount) {
      setState(() {
        _names.add(NameItem(name: _nameController.text));
        _nameController.clear();
      });
      // スクロールを最下部に移動
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          const SizedBox(height: 2),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '名前を入力',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onSubmitted: (_) => _addName(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: _addName,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: _names.asMap().entries.map((entry) {
                  final nameItem = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomCheckbox(
                              value: nameItem.isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  nameItem.isChecked = value ?? false;
                                });
                              },
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
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _names.removeAt(entry.key);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 