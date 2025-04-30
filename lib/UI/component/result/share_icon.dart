// ignore_for_file: use_build_context_synchronously

import 'package:drivepay/services/paypay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareIconButton extends StatelessWidget {
  final int perPersonAmount;
  const ShareIconButton({super.key, required this.perPersonAmount});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.ios_share, color: Colors.grey),
      iconSize: 25,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 300,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 10,
                      bottom: 10,
                    ),
                    child: const Text('共有', style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[500],
                    margin: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                      bottom: 10,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: perPersonAmount.toString()),
                      );
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).pop();
                          });
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: const Padding(
                              padding: EdgeInsets.all(13),
                              child: Text(
                                'コピーしました！',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              39,
                              39,
                              39,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.copy,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text('金額をコピーする'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      PayPayService.launchPayPay(
                        context: context,
                        amount: perPersonAmount,
                        message: 'DrivePay 相乗り代金',
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/paypay_icon.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 20),
                          const Text('PayPayで支払う'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        Clipboard.setData(ClipboardData(text: perPersonAmount.toString()));
      },
    );
  }
}
