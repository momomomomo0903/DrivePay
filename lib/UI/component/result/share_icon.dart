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
                  const Text('共有', style: TextStyle(fontSize: 18)),
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
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        const SizedBox(width: 20),
                        const Text('金額をコピーする'),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/paypay_icon.png'),
                      const SizedBox(width: 20),
                      const Text('PayPayで支払う'),
                    ],
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
