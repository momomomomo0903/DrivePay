import 'package:flutter/material.dart';
import '../checkbox.dart';
import 'package:drivepay/services/group_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameItem {
  String name;
  bool isChecked;
  
  NameItem({required this.name, this.isChecked = false});
}

class DefaulterList extends StatefulWidget {
  final int maxCount;
  final String? groupId;
  
  const DefaulterList({
    super.key,
    required this.maxCount,
    this.groupId,
  });

  @override
  State<DefaulterList> createState() => _DefaulterListState();
}

class _DefaulterListState extends State<DefaulterList> {
  final List<NameItem> _names = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      _loadGroupMembers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupMembers() async {
    if (widget.groupId == null) return;
    
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final members = await GroupService.fetchGroupMembers(
        uid: uid,
        groupId: widget.groupId!,
      );
      
      setState(() {
        _names.clear();
        for (var member in members) {
          _names.add(NameItem(name: member));
        }
      });
    } catch (e) {
      debugPrint('グループメンバーの取得に失敗しました: $e');
    }
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
          if (widget.groupId == null) ...[
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
          ],
          const SizedBox(height: 10),
          Container(
            height: widget.groupId == null ? 130 : 180,
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
                        if (widget.groupId == null)
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