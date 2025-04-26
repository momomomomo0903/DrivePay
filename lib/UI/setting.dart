import 'package:drivepay/logic/auth.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:drivepay/UI/component/webViewPage.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/UI/auth/auth_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/group.dart';
import 'package:drivepay/UI/drivehistory.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(isLoginProvider);
    final userName = ref.watch(userNameProvider);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '名前:$userName\nメールアドレス:$eMail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
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
                                  AuthLogout.LogoutLogic(ref, context);

                                  debugPrint(
                                    'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)}}',
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
                  onTap:
                      isLogin
                          ? () => _navigateToHistory(context)
                          : () => _navigateToLogin(context),
                ),
                _buildFeatureButton(
                  icon: Icons.info_outline,
                  label: '使い方',
                  onTap: () => _navigateToInfomation(context),
                ),
                _buildFeatureButton(
                  icon: Icons.group_add,
                  label: 'グループ作成',
                  onTap:
                      isLogin
                          ? () => _navigateToCreateGroup(context)
                          : () => _navigateToLogin(context),
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

  void _navigateToLogin(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'ログインしてください',
                    style: const TextStyle(
                      color: Color(0xFF45C4B0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "こちらの機能はログインをしていただくとご利用できます。",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF45C4B0)),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Color(0xFF45C4B0),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'キャンセル',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Color(0xFF45C4B0),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthLoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'ログイン',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DriveHistoryPage()),
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
      MaterialPageRoute(builder: (context) => const GroupPage()),
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
