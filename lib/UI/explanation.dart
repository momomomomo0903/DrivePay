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
                context: context,
                title: '1. 料金計算',
                content: '出発地と目的地を入力し、人数を選択することで、一人あたりの料金を自動計算します。',
                icon: Icons.calculate,
                detailPage: 'fare_calculation',
              ),
              _buildSection(
                context: context,
                title: '2. 支払い',
                content: 'PayPayを使用して、簡単に料金を支払うことができます。',
                icon: Icons.payment,
                detailPage: 'payment',
              ),
              _buildSection(
                context: context,
                title: '3. マップ機能',
                content: '現在地周辺のガソリンスタンドを地図上で素早く見つけることができます。',
                icon: Icons.map,
                detailPage: 'map',
              ),
              _buildSection(
                context: context,
                title: '4. グループ作成',
                content: 'ログインすることで、グループを作成し、メンバーと料金を共有できます。',
                icon: Icons.group,
                detailPage: 'group',
              ),
              _buildSection(
                context: context,
                title: '5. ドライブ履歴',
                content: '過去のドライブ履歴を確認することができます。',
                icon: Icons.history,
                detailPage: 'history',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required String detailPage,
  }) {
    return InkWell(
      onTap: () => _navigateToDetail(context, detailPage),
      child: Container(
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
          border: Border.all(
            color: const Color(0xFF45C4B0).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF45C4B0), size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF45C4B0),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF45C4B0),
                  size: 24,
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
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String detailPage) {
    // TODO: 各機能の詳細ページへの遷移を実装
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('$detailPage の詳細'),
            content: const Text('詳細ページは現在開発中です。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
