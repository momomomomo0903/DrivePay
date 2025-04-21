import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'dart:io' show Platform;

class PayPayService {
  // PayPayの送金URLを生成
  static String generatePayPayUrl({
    required int amount,
    required String message,
  }) {
    return 'paypay://send?amount=$amount&message=${Uri.encodeComponent(message)}';
  }

  // PayPayアプリを起動
  static Future<void> launchPayPay({
    required BuildContext context,
    required int amount,
    required String message,
  }) async {
    final Uri url = Uri.parse(
      generatePayPayUrl(amount: amount, message: message),
    );

    try {
      if (await url_launcher.canLaunchUrl(url)) {
        await url_launcher.launchUrl(
          url,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        // PayPayアプリがインストールされていない場合
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('PayPayアプリが見つかりません'),
                content: const Text('PayPayアプリのインストールが必要です。'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('App Storeを開く'),
                    onPressed: () async {
                      // PayPayのストアページを開く
                      final storeUrl =
                          Platform.isIOS
                              ? 'https://apps.apple.com/jp/app/paypay/id1435783608'
                              : 'https://play.google.com/store/apps/details?id=jp.ne.paypay.android.app';
                      final Uri storeUri = Uri.parse(storeUrl);
                      if (await url_launcher.canLaunchUrl(storeUri)) {
                        await url_launcher.launchUrl(storeUri);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('キャンセル'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PayPayアプリの起動に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
