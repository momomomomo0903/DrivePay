import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drivepay/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrivePay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF6FFFE)),
      ),
      home: const Firstpage(),
    );
  }
}
