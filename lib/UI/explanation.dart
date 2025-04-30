import 'package:flutter/material.dart';

class ExplanationPage extends StatelessWidget {
  const ExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使い方', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF45C4B0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: '1. 料金計算',
                content: '出発地と目的地を入力し、人数を選択することで、一人あたりの料金を自動計算します。',
                icon: Icons.calculate,
              ),
              _buildSection(
                title: '2. 支払い',
                content: 'PayPayを使用して、簡単に料金を支払うことができます。',
                icon: Icons.payment,
              ),
              _buildSection(
                title: '3. マップ機能',
                content: '現在地周辺のガソリンスタンドを地図上で素早く見つけることができます。',
                icon: Icons.map,
              ),
              _buildSection(
                title: '4. グループ作成',
                content: 'ログインすることで、グループを作成し、メンバーと料金を共有できます。',
                icon: Icons.group,
              ),
              _buildSection(
                title: '5. ドライブ履歴',
                content: '過去のドライブ履歴を確認することができます。',
                icon: Icons.history,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF45C4B0), size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45C4B0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
