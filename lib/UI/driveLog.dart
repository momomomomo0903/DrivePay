// ignore_for_file: file_names, unnecessary_string_interpolations
import 'package:drivepay/UI/driveLog_card.dart';
import 'package:drivepay/logic/auth.dart';
import 'package:drivepay/logic/firebase.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/state/dribeLog_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriveLogPage extends ConsumerStatefulWidget {
  const DriveLogPage({super.key});

  @override
  ConsumerState<DriveLogPage> createState() => _DriveLogPageState();
}

class _DriveLogPageState extends ConsumerState<DriveLogPage> {
  int distance = 150; // 総走行距離
  int uncollected = 0; // 未徴収件数
  @override
  Widget build(BuildContext context) {
    DB().getHistoryItems(ref);
    final historyItems = ref.watch(historyItemProvider);
    final isLogin = ref.watch(isLoginProvider);
    const youbiList = ['月', '火', '水', '木', '金', '土', '日']; // Dartでは 1=月, 7=日

    return !isLogin
        ? _navigateToLogin(context)
        : Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),

            children: [
              const SizedBox(height: 15),
              const Text(
                'ドライブ履歴',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff45C4B0),
                ),
              ), // メインカード
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: 270,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '総走行距離',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff45C4B0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '$distance',
                                        style: TextStyle(
                                          fontSize: 45.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff45C4B0),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'km',
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff45C4B0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '未徴収',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff45C4B0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '$uncollected',
                                        style: TextStyle(
                                          fontSize: 45.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff45C4B0),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        '件',
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff45C4B0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child:
                    historyItems.isEmpty
                        ? const Center(
                          child: Text(
                            'ドライブ履歴がありません',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff45C4B0),
                            ),
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: historyItems.length,
                          itemBuilder: (context, index) {
                            final item = historyItems[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Icon(
                                  Icons.circle,
                                  color:
                                      item[5] == 'true'
                                          ? Colors.white
                                          : Colors.red,
                                  size: 17.0,
                                ),
                                tileColor: const Color(0xFF45C4B0),
                                title: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '${int.parse(item[0].split('/')[1])}/${int.parse(item[0].split('/')[2])}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '(${youbiList[(DateTime.parse(item[0].replaceAll('/', '-')).weekday) - 1 % 7]})',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${item[1]} → ${item[2]}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DrivelogCard(item: item),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
  }

  Widget _navigateToLogin(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
  }
}
