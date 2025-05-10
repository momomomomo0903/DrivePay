import 'package:flutter/material.dart';
import 'error.dart'; 
class NetworkUI {
  // ネットワーク接続がされていない際のUI
  void showNetworkError(BuildContext context){
    Errorpage().errorUI(context,'インターネットに失敗しました。');
    }
  Widget networkErrorUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Drive Pay",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff45c4b0),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 110),
              Column(
                children: [
                  Image.asset(
                    'assets/images/first-page.png',
                    width: 280,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 15),
                const Text( "ネットワーク接続がされていません",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,),
                const SizedBox(height: 10),
                const Text(
                      "ネットワーク状況を確認してください",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,   
                ),
            ],
          ),
        ),
      ),
    );
  }
}
