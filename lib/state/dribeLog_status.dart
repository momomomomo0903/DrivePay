// ignore_for_file: file_names
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyItemProvider = StateProvider<List<List<dynamic>>>(
  (ref) => [],
); // ドライブ履歴のリスト
