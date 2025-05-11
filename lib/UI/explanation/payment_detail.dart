import 'package:flutter/material.dart';
import 'package:drivepay/UI/fotter_menu.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い機能の使い方', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF45C4B0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff45C4B0),
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Icon(Icons.groups_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Icon(Icons.map_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Icon(Icons.brightness_low_rounded),
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: 3,
        onTap: (index) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: index)),
            (route) => false,
          );
        },
      ),
      body: Stack(
        children: [
          // 背景の円
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.15,
            left: -50,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F8F5),
              ),
            ),
          ),
          // メインコンテンツ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // アプリのスクリーンショット
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/payment_01.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                // メインタイトル
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '一人あたりの金額と支払い状況が\nすぐわかる！',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                // 説明文
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '計算結果として一人あたりの金額が表示され\n誰からお金を受け取ったかチェックできます！\n金額のコピーや、PayPayにも対応していて、\nやりとりもスムーズに行えます。',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
