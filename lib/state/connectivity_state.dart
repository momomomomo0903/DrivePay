import 'package:riverpod/riverpod.dart';

final connectivityCheckProvider = StateProvider<bool>(
  (ref) => false,
); // ネットワーク接続しているかの確認
