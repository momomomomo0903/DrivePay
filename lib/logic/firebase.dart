// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DB {
  static Future<void> dataBaseSetWrite(WidgetRef ref) async {
    try {
      final name = ref.watch(userNameProvider);
      final uid = ref.watch(userIdProvider);
      final mail = ref.watch(eMailProvider);
      final mailLogin = ref.watch(isMailLoginProvider);
      final GoogleLogin = ref.watch(isGoogleLoginProvider);

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
        'mailLogin': mailLogin,
        'GoogleLogin': GoogleLogin,
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
      final mailLogin = ref.watch(isMailLoginProvider);
      final GoogleLogin = ref.watch(isGoogleLoginProvider);

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
        'mailLogin': mailLogin,
        'GoogleLogin': GoogleLogin,
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
      ref.read(userNameProvider.notifier).state =
          doc.data()?['username'] ?? 'ゲスト';
      ref.read(eMailProvider.notifier).state = doc.data()?['email'];
      ref.read(isGoogleLoginProvider.notifier).state =
          doc.data()?['GoogleLogin'];
      ref.read(isMailLoginProvider.notifier).state = doc.data()?['mailLogin'];
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
}
