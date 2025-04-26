// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:drivepay/UI/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drivepay/services/paypay.dart';

class ResultPage extends StatelessWidget {
  final int perPersonAmount;
  final int peopleCount;
  final double distance;

  const ResultPage({
    super.key,
    required this.perPersonAmount,
    required this.peopleCount,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    int totalAmount = perPersonAmount * peopleCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 100, bottom: 150),
                decoration: const BoxDecoration(color: Color(0xFF45C4B0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '¥$perPersonAmount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // アイコン＋テキストを縦に並べる
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.link, color: Colors.white),
                          iconSize: 40,
                          padding: EdgeInsets.zero, // アイコン周りの余白をなくす
                          constraints: const BoxConstraints(), // 最小サイズ制限を解除
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: perPersonAmount.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('コピーしました')),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '金額をコピー',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12, // 小さめに
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 192, 192, 192),
                            ),
                          ),
                        ),
                        child: Text(
                          '距離　　　　${distance.toStringAsFixed(1)} Km',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8F8F8F),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                          '一人　　　　${perPersonAmount}円 × ${peopleCount}人',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8F8F8F),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          '合計　　　　${totalAmount}円',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8F8F8F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const SizedBox(height: 30),
                      // PayPayボタンを追加
                      ElevatedButton.icon(
                        onPressed: () {
                          PayPayService.launchPayPay(
                            context: context,
                            amount: perPersonAmount,
                            message: 'DrivePay 相乗り代金',
                          );
                        },
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: const Text('PayPayで支払う'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFFF0033,
                          ), // PayPayのブランドカラー
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.only(
                            left: 70.0,
                            right: 70.0,
                          ),
                          backgroundColor: const Color(0xFF45C4B0),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('ホームに戻る'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
