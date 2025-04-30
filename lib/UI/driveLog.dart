// ignore_for_file: file_names
import 'package:drivepay/logic/firebase.dart';
import 'package:drivepay/state/dribeLog_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriveLogPage extends ConsumerStatefulWidget {
  const DriveLogPage({super.key});

  @override
  ConsumerState<DriveLogPage> createState() => _DriveLogPageState();
}

class _DriveLogPageState extends ConsumerState<DriveLogPage> {
  int distance = 150; // 総走行距離
  int uncollected = 0; // 未徴収件数
  @override
  Widget build(BuildContext context) {
    DB().getHistoryItems(ref);
    final historyItems = ref.watch(historyItemProvider);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'ドライブ履歴',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff45C4B0),
              ),
            ), // メインカード
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: 270,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '総走行距離',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff45C4B0),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      '$distance',
                                      style: TextStyle(
                                        fontSize: 45.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff45C4B0),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'km',
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff45C4B0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '未徴収',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff45C4B0),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      '$uncollected',
                                      style: TextStyle(
                                        fontSize: 45.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff45C4B0),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '件',
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff45C4B0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            historyItems.isEmpty
                ? const Center(
                  child: Text(
                    'ドライブ履歴がありません',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff45C4B0),
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: historyItems.length,
                  itemBuilder: (context, index) {
                    final item = historyItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: item[6] == 'true' ? Colors.white : Colors.red,
                        ),
                        title: Row(
                          children: [
                            Column(children: [Text(item[0])]),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Text('${item[1]}→${item[2]}'),
                                Text('${item[3]}円/人'),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
