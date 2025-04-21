import 'package:riverpod/riverpod.dart';

final isLoginProvider = StateProvider<bool>((ref) => false); // ログインしているかの確認
final isMailLoginProvider = StateProvider<bool>(
  (ref) => false,
); // メールログインをしているかの確認
final isGoogleLoginProvider = StateProvider<bool>(
  (ref) => false,
); //Googleログインをしているかの確認
final userNameProvider = StateProvider<String>((ref) => "ゲスト"); // 名前
final userIdProvider = StateProvider<String>((ref) => "Null"); // ユーザーID
final eMailProvider = StateProvider<String>((ref) => "ログインしてください"); // メール
