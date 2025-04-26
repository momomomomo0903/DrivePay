import 'package:flutter/material.dart';

class DriveHistoryPage extends StatelessWidget {
  const DriveHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ドライブ履歴', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF45C4B0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('ここにドライブ履歴を表示します', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
