// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/state/dribeLog_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DB {
  static Future<void> dataBaseSetWrite(WidgetRef ref) async {
    try {
      final name = ref.watch(userNameProvider);
      final uid = ref.watch(userIdProvider);
      final mail = ref.watch(eMailProvider);
      final fuelEfficiency = ref.watch(fuelEfficiencyProvider);

      if (uid == null || uid == "ログインしてください" || uid == "Null") {
        debugPrint("無効なUIDなので書き込みをスキップしました");
        return;
      }
      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'username': name,
        'email': mail,
        'fuelEfficiency': fuelEfficiency,
        'updateDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("書き込みができませんでした。");
    }
  }

  static Future<void> dataBaseUpdateWrite(WidgetRef ref) async {
    try {
      final name = ref.watch(userNameProvider);
      final uid = ref.watch(userIdProvider);
      final mail = ref.watch(eMailProvider);
      final fuelEfficiency = ref.watch(fuelEfficiencyProvider);

      if (uid == null || uid == "ログインしてください" || uid == "Null") {
        debugPrint("無効なUIDなので書き込みをスキップしました");
        return;
      }
      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(uid).update({
        'uid': uid,
        'username': name,
        'email': mail,
        'fuelEfficiency': fuelEfficiency,
        'updateDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("書き込みができませんでした。");
    }
  }

  static Future<void> dataBaseWatch(WidgetRef ref) async {
    try {
      final uid = ref.watch(userIdProvider);

      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final doc = await firestore.collection('users').doc(uid).get();
      
      // ユーザー名とメールアドレスの設定
      ref.read(userNameProvider.notifier).state =
          doc.data()?['username'] ?? 'ゲスト';
      ref.read(eMailProvider.notifier).state = doc.data()?['email'];
      
      // 燃費データの設定（存在しない場合は11.3をデフォルト値として設定）
      final fuelEfficiency = doc.data()?['fuelEfficiency'];
      if (fuelEfficiency == null) {
        ref.read(fuelEfficiencyProvider.notifier).state = '11.3';
        // デフォルト値をデータベースに保存
        await firestore.collection('users').doc(uid).set({
          'fuelEfficiency': '11.3',
        }, SetOptions(merge: true)); // merge: true で既存のデータを保持したまま更新
      } else {
        ref.read(fuelEfficiencyProvider.notifier).state = fuelEfficiency;
      }
    } catch (e) {
      debugPrint("読み込みができませんでした。");
    }
  }

  static Future<void> TimeStampWrite(WidgetRef ref, String info) async {
    final uid = ref.watch(userIdProvider);
    // firestoreに書き込み(user)
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(uid).update({
      'updateDate': FieldValue.serverTimestamp(),
    });
  }

  // ドライブ履歴のリストを取得する関数
  Future<void> getHistoryItems(WidgetRef ref) async {
    try {
      final uid = ref.watch(userIdProvider);
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('drivelog')
              .get();
      final historyList =
          snapshot.docs.map((doc) {
            final data = doc.data();
            final timestamp = data['date'];
            return [
              timestamp != null
                  ? _formatDateToYMD((timestamp as Timestamp).toDate())
                  : '',
              data['startPlace'] ?? '',
              data['endPlace'] ?? '',
              data['distance'] ?? '',
              data['money'] ?? '',
              data['groupId'] ?? '',
              data['member'] ?? [],
              data['memo'] ?? '',
              data['docId'] ?? doc.id,
            ];
          }).toList();
      ref.read(historyItemProvider.notifier).state =
          historyList.cast<List<dynamic>>();
    } catch (e) {
      debugPrint("ドライブ履歴の取得に失敗しました: $e");
    }
  }

  String _formatDateToYMD(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  /// ドライブ履歴をFirestoreに追加する
  Future<void> firstAddDriveHistory(
    WidgetRef ref,
    String startPlace,
    String endPlace,
    double distance,
    int money,
    String groupId
  ) async {
    try {
      final uid = ref.watch(userIdProvider);
      final group =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('groups')
              .doc(groupId)
              .get();

      final members =
          group['members'].first is String
              ? group['members']
                  .map((name) => {'name': name, 'paid': false})
                  .toList()
              : group['members'];

      if (members.isEmpty) {
        debugPrint('グループにメンバーがいません。');
        return;
      }

      // [[名前, false], ...] の形式に変換
      final memberList =
          members.map((name) => {'name': name, 'paid': false}).toList();

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('drivelog')
          .doc();
      await docRef.set({
            'date': FieldValue.serverTimestamp(),
            'startPlace': startPlace,
            'endPlace': endPlace,
            'distance': distance,
            'money': money,
            'groupId': groupId,
            'member': memberList,
            'memo': '',
            'docId': docRef.id.toString(),
          });
      await getHistoryItems(ref);

      debugPrint('書き込み成功');
    } catch (e) {
      debugPrint('書き込みエラー: $e');
      rethrow;
    }
  }

  static Future<void> writeMemo(WidgetRef ref,{
    required item,
  }) async {
    try {
      final uid = ref.read(userIdProvider);
      final firestore = FirebaseFirestore.instance;

      await firestore
          .collection('users')
          .doc(uid)
          .collection('drivelog')
          .doc(item[8])
          .update({'memo': item[7]});

      debugPrint('メモ更新成功');
    } catch (e) {
      debugPrint('メモ更新失敗: $e');
    }
  }
}
