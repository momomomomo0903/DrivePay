import 'package:drivepay/UI/fotter_menu.dart';
import 'package:drivepay/logic/auth.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:drivepay/UI/component/webViewPage.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/group.dart';
import 'package:drivepay/UI/drivehistory.dart';
import 'package:drivepay/UI/explanation.dart';

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
          height: 360,
          margin: EdgeInsets.zero,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 10, bottom: 20,),
          decoration: const BoxDecoration(color: Color(0xFFDCFFF9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // メインカード
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFFF6FFFE),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Color(0xFF45C4B0), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // メールアドレス
                      Text("メールアドレス", style: TextStyle(
                        color: Color(0xFF45C4B0), fontSize: 13, fontWeight: FontWeight.w500)),
                      SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFD1F3EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          eMail,
                          style: TextStyle(
                            color: Color(0xFF45C4B0),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      // 名前
                      Row(
                        children: [
                          Text("名前", style: TextStyle(
                            color: Color(0xFF45C4B0), fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(width: 4),
                          Icon(Icons.edit, size: 13, color: Color(0xFF45C4B0)),
                        ],
                      ),
                      SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFD1F3EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          userName,
                          style: TextStyle(
                            color: Color(0xFF45C4B0),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      // 燃費
                      Row(
                        children: [
                          Text("自家用車の燃費", style: TextStyle(
                            color: Color(0xFF45C4B0), fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(width: 4),
                          Icon(Icons.edit, size: 13, color: Color(0xFF45C4B0)),
                        ],
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD1F3EF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "00.0",
                                    style: TextStyle(
                                      color: Color(0xFF45C4B0),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text("Km/L", style: TextStyle(
                                  color: Color(0xFF45C4B0), fontSize: 24, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7ED6C1),
                              foregroundColor: Colors.white,
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {},
                            child: Text("変更を保存", style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ログインボタン
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: !isLogin
                ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF45C4B0),
                  ),
                  onPressed: () {
                  GoogleSignin.signInWithGoogle(ref, context);
                  },
                  child: Text("Googleでログイン"),
                  )
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF45C4B0),
                    ),
                    onPressed: () {
                      AuthLogout.LogoutLogic(ref, context);
                      debugPrint(
                        'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)}}',
                      );
                    },
                    child: Text("ログアウト"),
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
                        GoogleSignin.signInWithGoogle(ref, context);
                        Navigator.pop(context);
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

      MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 1)),
    );
  }

  void _navigateToInfomation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExplanationPage()),
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