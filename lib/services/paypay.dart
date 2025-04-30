import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class PayPayService {
  // PayPayの送金URLを生成
  static String generatePayPayUrl({
    required int amount,
    required String message,
  }) {
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'paypayjp://send?amount=$amount&message=$encodedMessage&currency=JPY';
    print('Generated PayPay URL: $url');
    return url;
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
      print('Attempting to launch PayPay with URL: ${url.toString()}');
      final canLaunch = await canLaunchUrl(url);
      print('Can launch PayPay: $canLaunch');

      if (!canLaunch) {
        print('PayPay app not found');
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
                      final storeUrl =
                          Platform.isIOS
                              ? 'https://apps.apple.com/jp/app/paypay/id1435783608'
                              : 'https://play.google.com/store/apps/details?id=jp.ne.paypay.android.app';
                      print('Opening store URL: $storeUrl');
                      final Uri storeUri = Uri.parse(storeUrl);
                      if (await canLaunchUrl(storeUri)) {
                        await launchUrl(storeUri);
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
        return;
      }

      print('Launching PayPay app...');
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      print('PayPay app launched successfully');
    } catch (e) {
      print('Error launching PayPay: $e');
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
