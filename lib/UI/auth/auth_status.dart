import 'package:riverpod/riverpod.dart';

final isLoginProvider = StateProvider<bool>((ref) => false); // ログインしているかの確認
final userNameProvider = StateProvider<String>((ref) => "ゲスト"); // ユーザー名
final userIdProvider = StateProvider<String>((ref) => "Null");  // ユーザーID
final eMailProvider = StateProvider<String>((ref) => "ログインしてください"); // メール
