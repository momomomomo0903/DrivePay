import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NetworkLogic {
  // ネットワークの接続状態の確認
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  // ネットワーク状態の確認
  Future<bool> networkCheck() async {
    bool isConnection = await networkConnection();
    debugPrint("ネットワーク状態:$isConnection");
    return isConnection;
  }

  // ネットワーク状態の取得（Web・モバイル両対応）
  Future<bool> networkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // Webの場合：connectivity_plus だけで判断
    if (kIsWeb) {
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint("【Web】ネットワーク接続なし");
        return false;
      } else {
        debugPrint("【Web】ネットワーク接続あり");
        return true;
      }
    }

    // モバイル（iOS/Android）の場合：Googleに接続して判定
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint("【Mobile】ネットワーク接続あり");
        return true;
      } else {
        debugPrint("【Mobile】Google接続失敗");
        return false;
      }
    } catch (e) {
      debugPrint("【Mobile】ネットワーク接続エラー: $e");
      return false;
    }
  }
}
