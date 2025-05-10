import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drivepay/logic/network.dart';
import 'package:drivepay/state/map_status.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drivepay/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnection(); // 初回起動時
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    bool connected = await NetworkLogic().networkCheck();
    ref.read(connectivityCheckProvider.notifier).state = connected;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrivePay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x00DCFFF9)),
      ),
      home: const Firstpage(),
    );
  }
}
