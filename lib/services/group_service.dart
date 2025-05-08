import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  //ユーザーのグループ一覧を取得
  static Future<List<Map<String, dynamic>>> fetchUserGroups(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('groups')
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<List<String>> fetchGroupMembers({
    required String uid,
    required String groupId,
  }) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .get();

    final data = doc.data();
    if (data != null && data.containsKey('members')) {
      return List<String>.from(data['members']);
    } else {
      return [];
    }
  }
}
