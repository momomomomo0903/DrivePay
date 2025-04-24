import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkLogic {
  // ネットワークの接続状態の確認
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  // ネットワーク状態の確認
  Future<bool> networkCheck() async {
    bool isConnection = await networkConnection();
    debugPrint("ネットワーク状態:$isConnection");
    return isConnection;
  }

  // ネットワーク状態の取得
  Future<bool> networkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == connectionStatus) {
      return false;
    }
    try {
      var result = [];
      result = await InternetAddress.lookup('google.com'); //ネットワーク接続があるかの確認
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
