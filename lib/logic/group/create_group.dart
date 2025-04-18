import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroup {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createGroup({
    required String groupName,
    required List<String> members,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('ユーザーがログインしていません');
        throw Exception('ログインしていません');
      }

      print('Creating group for user: ${user.uid}');
      print('Group name: $groupName');
      print('Members: $members');

      if (groupName.isEmpty) {
        throw Exception('グループ名を入力してください');
      }

      if (members.any((member) => member.isEmpty)) {
        throw Exception('メンバー名を全て入力してください');
      }

      final groupId = DateTime.now().millisecondsSinceEpoch.toString();
      print('Generated group ID: $groupId');
      
      final groupData = {
        'groupId': groupId,
        'groupName': groupName,
        'members': members,
        'ownerId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      print('Saving group data: $groupData');

      // ユーザーごとのサブコレクションに保存
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .doc(groupId)
          .set(groupData);

      print('Group saved successfully');

      return groupId;
    } catch (e) {
      print('Error creating group: $e');
      print('Error stack trace: ${StackTrace.current}');
      throw Exception('グループの作成に失敗しました: ${e.toString()}');
    }
  }

  Future<void> addMember({
    required String groupId,
    required String memberName,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('ユーザーがログインしていません');
        throw Exception('ログインしていません');
      }

      print('Adding member to group: $groupId');
      print('New member: $memberName');

      if (memberName.isEmpty) {
        throw Exception('メンバー名を入力してください');
      }

      final groupRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .doc(groupId);
      final groupDoc = await groupRef.get();

      if (!groupDoc.exists) {
        print('Group not found: $groupId');
        throw Exception('グループが見つかりません');
      }

      final currentMembers = List<String>.from(groupDoc.data()?['members'] ?? []);
      print('Current members: $currentMembers');

      if (currentMembers.contains(memberName)) {
        throw Exception('このメンバーは既に追加されています');
      }

      currentMembers.add(memberName);
      print('Updated members: $currentMembers');
      
      await groupRef.update({
        'members': currentMembers,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Member added successfully');
    } catch (e) {
      print('Error adding member: $e');
      print('Error stack trace: ${StackTrace.current}');
      throw Exception('メンバーの追加に失敗しました: ${e.toString()}');
    }
  }
}
