import 'package:drivepay/UI/component/result/share_icon.dart';
import 'package:drivepay/UI/component/to_driveLogPage_button.dart';
import 'package:drivepay/UI/memoInput.dart';
import 'package:flutter/material.dart';

class DrivelogCard extends StatelessWidget {
  final List<dynamic> item;

  const DrivelogCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final int moneyPerPerson = int.tryParse(item[4].toString()) ?? 0;
    final int memberCount = (item[6] as List).length;
    final int totalMoney = moneyPerPerson * memberCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${item[0]}'),
        backgroundColor: const Color(0xFF45C4B0),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 100, bottom: 100),
                decoration: const BoxDecoration(color: Color(0xFF45C4B0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Text(
                          '一人あたり',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '¥$moneyPerPerson',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      '距離　　　　${item[3]} Km',
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
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Text(
                      '一人　　　　$moneyPerPerson円 × $memberCount人',
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
                      '合計　　　　$totalMoney円',
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
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemoInputPage(item: item),
                              ),
                            );
                          },
                          child: Text(
                            '編集',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Text('${item[7]}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToDriveLogpageButton(),
                        ShareIconButton(perPersonAmount: item[4]),
                      ],
                    ),
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
