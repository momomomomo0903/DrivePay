import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        debugPrint('ユーザーがログインしていません');
        throw Exception('ログインしていません');
      }

      debugPrint('Creating group for user: ${user.uid}');
      debugPrint('Group name: $groupName');
      debugPrint('Members: $members');

      if (groupName.isEmpty) {
        throw Exception('グループ名を入力してください');
      }

      if (members.any((member) => member.isEmpty)) {
        throw Exception('メンバー名を全て入力してください');
      }

      final groupId = DateTime.now().millisecondsSinceEpoch.toString();
      debugPrint('Generated group ID: $groupId');
      
      final groupData = {
        'groupId': groupId,
        'groupName': groupName,
        'members': members,
        'ownerId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      debugPrint('Saving group data: $groupData');

      // ユーザーごとのサブコレクションに保存
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .doc(groupId)
          .set(groupData);

      debugPrint('Group saved successfully');

      return groupId;
    } catch (e) {
      debugPrint('Error creating group: $e');
      debugPrint('Error stack trace: ${StackTrace.current}');
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
        debugPrint('ユーザーがログインしていません');
        throw Exception('ログインしていません');
      }

      debugPrint('Adding member to group: $groupId');
      debugPrint('New member: $memberName');

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
        debugPrint('Group not found: $groupId');
        throw Exception('グループが見つかりません');
      }

      final currentMembers = List<String>.from(groupDoc.data()?['members'] ?? []);
      debugPrint('Current members: $currentMembers');

      if (currentMembers.contains(memberName)) {
        throw Exception('このメンバーは既に追加されています');
      }

      currentMembers.add(memberName);
      debugPrint('Updated members: $currentMembers');
      
      await groupRef.update({
        'members': currentMembers,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Member added successfully');
    } catch (e) {
      debugPrint('Error adding member: $e');
      debugPrint('Error stack trace: ${StackTrace.current}');
      throw Exception('メンバーの追加に失敗しました: ${e.toString()}');
    }
  }
}
