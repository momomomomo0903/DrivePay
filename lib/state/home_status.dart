import 'package:riverpod/riverpod.dart';

final fromProvider = StateProvider<String>((ref) => '');
final toProvider = StateProvider<String>((ref) => '');
final groupIdProvider = StateProvider<String>((ref) => '');