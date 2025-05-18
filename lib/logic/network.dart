import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// ネットワーク接続状態を管理するクラス
class NetworkLogic {
  static const String _testHost = 'google.com';
  static const Duration _timeoutDuration = Duration(seconds: 5);

  /// ネットワークの接続状態を確認する
  ///
  /// 戻り値: 接続可能な場合はtrue、それ以外はfalse
  Future<bool> networkCheck() async {
    try {
      final isConnected = await _checkInternetConnection();
      debugPrint('ネットワーク状態: ${isConnected ? '接続中' : '未接続'}');
      return isConnected;
    } catch (e) {
      debugPrint('ネットワーク状態の確認中にエラーが発生しました: $e');
      return false;
    }
  }

  /// インターネット接続を確認する
  Future<bool> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // オフライン状態の場合は即座にfalseを返す
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup(
        _testHost,
      ).timeout(_timeoutDuration);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      debugPrint('ソケットエラー: $e');
      return false;
    } on TimeoutException catch (e) {
      debugPrint('タイムアウトエラー: $e');
      return false;
    } catch (e) {
      debugPrint('予期せぬエラー: $e');
      return false;
    }
  }

  /// 現在の接続状態を取得する
  Future<List<ConnectivityResult>> getCurrentConnectivity() async {
    try {
      return await Connectivity().checkConnectivity();
    } catch (e) {
      debugPrint('接続状態の取得中にエラーが発生しました: $e');
      return [ConnectivityResult.none];
    }
  }
}
