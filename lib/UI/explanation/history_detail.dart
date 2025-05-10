import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ドライブ履歴の使い方', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF45C4B0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
