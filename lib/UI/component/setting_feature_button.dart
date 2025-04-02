import 'package:drivepay/UI/firstPage.dart';
import 'package:flutter/material.dart';

class FeatureButtonGroup extends StatelessWidget {
  const FeatureButtonGroup({super.key});

//一旦全部firstpageに飛ばしてます
  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Firstpage(),
      ),
    );
  }
   void _navigateToInfomation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Firstpage(),
      ),
    );
  }
   void _navigateToCreateGroup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Firstpage(),
      ),
    );
  }
   void _navigateToContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Firstpage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 35,
        crossAxisSpacing: 35,
        childAspectRatio: 1,
        children: [
          _buildFeatureButton(
            icon: Icons.history,
            label: 'ドライブ履歴',
            onTap: () => _navigateToHistory(context),
          ),
          _buildFeatureButton(
            icon: Icons.info_outline,
            label: '使い方',
            onTap: () => _navigateToInfomation(context),
          ),
          _buildFeatureButton(
            icon: Icons.group_add,
            label: 'グループ作成',
            onTap: () => _navigateToCreateGroup(context),
          ),
          _buildFeatureButton(
            icon: Icons.mail_outline,
            label: 'お問い合わせ',
            onTap: () => _navigateToContact(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF45C4B0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
