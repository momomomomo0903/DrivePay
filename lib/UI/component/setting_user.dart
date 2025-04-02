import 'package:drivepay/UI/firstPage.dart';
import 'package:flutter/material.dart';

class UserGroup extends StatelessWidget {
  const UserGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(top: 10,bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFDCFFF9),
      ),
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
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '名前:ムンチャクッパス\nメールアドレス:munchaku@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}