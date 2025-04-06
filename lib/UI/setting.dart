import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:drivepay/UI/component/webViewPage.dart';
import 'package:drivepay/UI/auth/auth_status.dart';
import 'package:drivepay/UI/auth/auth_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(isLoginProvider);
    final UserName = ref.watch(userNameProvider);
    final eMail = ref.watch(eMailProvider);
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          decoration: const BoxDecoration(color: Color(0xFFDCFFF9)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // 円形の画像
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // メインカード
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Container(
                  width: 270,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF45C4B0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '名前:$UserName\nメールアドレス:$eMail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          !isLogin
                              ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AuthLoginPage(),
                                    ),
                                  );
                                },
                                child: Text("ログイン"),
                              )
                              : ElevatedButton(
                                onPressed: () {
                                  ref.read(isLoginProvider.notifier).state =
                                      false;
                                  ref.read(userNameProvider.notifier).state =
                                      "ゲスト";
                                  ref.read(eMailProvider.notifier).state =
                                      "ログインしてください";
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(),
                                    ),
                                  );
                                },
                                child: Text("ログアウト"),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Padding(
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
          ),
        ),
      ],
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Firstpage()),
    );
  }

  void _navigateToInfomation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Firstpage()),
    );
  }

  void _navigateToCreateGroup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Firstpage()),
    );
  }

  void _navigateToContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const WebViewPage(
              title: 'お問い合わせフォーム',
              url:
                  'https://docs.google.com/forms/d/e/1FAIpQLSe1UBYrgiDekPvA2RMLPVZvsrQwQdJ0j98iNiNZDyy1m6Z3ZQ/viewform?usp=header',
            ),
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
            Icon(icon, size: 32, color: Colors.white),
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
