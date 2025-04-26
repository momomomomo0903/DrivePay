import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupController extends StateNotifier<GroupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GroupController() : super(GroupState(isLoading: true, groups: [])) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        state = state.copyWith(isLoading: false, groups: []);
        return;
      }

      final groupsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .get();

      final groups = groupsSnapshot.docs.map((doc) {
        final groupData = doc.data();
        return {
          'id': groupData['groupId'],
          'name': groupData['groupName'],
          'members': List<String>.from(groupData['members']),
          'ownerId': groupData['ownerId'],
        };
      }).toList();

      state = state.copyWith(isLoading: false, groups: groups);
    } catch (e) {
      debugPrint('Error loading groups: $e');
      state = state.copyWith(isLoading: false, groups: []);
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .doc(groupId)
          .delete();
      loadGroups();
    } catch (e) {
      debugPrint('Error deleting group: $e');
      rethrow;
    }
  }

  Future<void> updateGroup(String groupId, String name, List<String> members) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .doc(groupId)
          .update({
        'groupName': name,
        'members': members,
      });
      loadGroups();
    } catch (e) {
      debugPrint('Error updating group: $e');
      rethrow;
    }
  }
}

class GroupState {
  final bool isLoading;
  final List<Map<String, dynamic>> groups;

  GroupState({
    required this.isLoading,
    required this.groups,
  });

  GroupState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? groups,
  }) {
    return GroupState(
      isLoading: isLoading ?? this.isLoading,
      groups: groups ?? this.groups,
    );
  }
}

final groupControllerProvider = StateNotifierProvider<GroupController, GroupState>((ref) {
  return GroupController();
}); 