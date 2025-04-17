import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'createGroup.dart';

class GroupPage extends ConsumerStatefulWidget {
  const GroupPage({super.key});

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _groups = [];
        });
        return;
      }

      print('Loading groups for owner: ${user.uid}');

      // オーナーが作成したグループのみを取得
      final groupsSnapshot = await _firestore
          .collection('groups')
          .where('ownerId', isEqualTo: user.uid)
          .get();

      print('Number of owned groups: ${groupsSnapshot.docs.length}');

      final groups = groupsSnapshot.docs.map((doc) {
        final groupData = doc.data();
        return {
          'id': groupData['groupId'],
          'name': groupData['groupName'],
          'members': List<String>.from(groupData['members']),
          'ownerId': groupData['ownerId'],
        };
      }).toList();

      setState(() {
        _isLoading = false;
        _groups = groups;
      });
    } catch (e) {
      print('Error loading groups: $e');
      setState(() {
        _isLoading = false;
        _groups = [];
      });
    }
  }

  Future<void> _deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
      _loadGroups(); // リストを更新
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('グループを削除しました'),
          backgroundColor: Color(0xff45c4b0),
        ),
      );
    } catch (e) {
      print('Error deleting group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('グループの削除に失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmDialog(String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('グループの削除'),
        content: Text('「$groupName」を削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGroup(groupId);
            },
            child: Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showMembersModal(List<String> members) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'メンバー一覧',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: members.map((name) => ListTile(
                    title: Text(name),
                    leading: Icon(Icons.person),
                  )).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditGroupDialog(Map<String, dynamic> group) {
    final TextEditingController nameController = TextEditingController(text: group['name']);
    List<String> currentMembers = List<String>.from(group['members']);
    final TextEditingController newMemberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'グループを編集',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'グループ名',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'グループ名を入力',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'メンバー',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...currentMembers.map((name) => ListTile(
                        title: Text(name),
                        leading: Icon(Icons.person),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              currentMembers.remove(name);
                            });
                          },
                        ),
                      )).toList(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: newMemberController,
                                decoration: InputDecoration(
                                  hintText: 'メンバー名を入力',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Color(0xFF45C4B0)),
                              onPressed: () {
                                final newMember = newMemberController.text.trim();
                                if (newMember.isEmpty) return;
                                
                                if (!currentMembers.contains(newMember)) {
                                  setState(() {
                                    currentMembers.add(newMember);
                                    newMemberController.clear();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF45C4B0),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            try {
                              await _firestore
                                  .collection('groups')
                                  .doc(group['id'])
                                  .update({
                                'groupName': nameController.text.trim(),
                                'members': currentMembers,
                              });
                              
                              Navigator.of(context).pop();
                              _loadGroups();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('グループを更新しました'),
                                  backgroundColor: Color(0xFF45C4B0),
                                ),
                              );
                            } catch (e) {
                              print('Error updating group: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('グループの更新に失敗しました'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Text(
                            '保存',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'グループ一覧',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff45c4b0),
      ),
      backgroundColor: Color(0xffDCFFF9),
      floatingActionButton: FloatingActionButton(
        heroTag: 'uniqueGroupPageFAB',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()),
          ).then((_) => _loadGroups());
        },
        backgroundColor: Color(0xff45c4b0),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? Center(
                  child: Text(
                    'グループがありません\n右下の+ボタンから作成してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return Card(
                      color: const Color(0xFFffffff),
                      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showMembersModal(group['members']),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   radius: 25,
                                //   backgroundImage: AssetImage(group['image']),
                                // ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    group['name'],
                                    style: TextStyle(
                                      color: Color(0xff45c4b0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: Color(0xff45c4b0)),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showEditGroupDialog(group);
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmDialog(group['id'], group['name']);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Color(0xFF45C4B0)),
                                          SizedBox(width: 8),
                                          Text('編集'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('削除', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
