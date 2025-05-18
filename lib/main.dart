import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drivepay/logic/network.dart';
import 'package:drivepay/state/connectivity_state.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drivepay/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00DCFFF9)),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}

Future<void> initializeApp() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('アプリケーションの初期化中にエラーが発生しました: $e');
    rethrow;
  }
}

void main() async {
  try {
    await initializeApp();
    runApp(const ProviderScope(child: DrivePayApp()));
  } catch (e) {
    debugPrint('アプリケーションの起動中にエラーが発生しました: $e');
  }
}

class DrivePayApp extends ConsumerStatefulWidget {
  const DrivePayApp({super.key});

  @override
  ConsumerState<DrivePayApp> createState() => _DrivePayAppState();
}

class _DrivePayAppState extends ConsumerState<DrivePayApp> {
  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    _checkConnection(); // 初回起動時
    Connectivity().onConnectivityChanged.listen(
      (_) => _checkConnection(),
      onError: (error) {
        debugPrint('接続状態の監視中にエラーが発生しました: $error');
      },
    );
  }

  Future<void> _checkConnection() async {
    try {
      final connected = await NetworkLogic().networkCheck();
      ref.read(connectivityCheckProvider.notifier).state = connected;
    } catch (e) {
      debugPrint('ネットワーク接続の確認中にエラーが発生しました: $e');
      ref.read(connectivityCheckProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrivePay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Firstpage(),
    );
  }
}
