import 'package:flutter/material.dart';

class NetworkUI {
  // ネットワーク接続がされていない際のUI
  Widget networkErrorUI() {
    return Column(
      children: [
        Text("ネットワーク接続がされていません", style: TextStyle(fontSize: 40)),
        SizedBox(height: 10),
        Text("ネットワーク状況を確認してください", style: TextStyle(fontSize: 40)),
      ],
    );
  }
}
