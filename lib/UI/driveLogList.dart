// ignore_for_file: file_names
import 'package:drivepay/logic/firebase.dart';
import 'package:drivepay/state/dribeLog_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriveLogListPage {
  Widget driveLogList(BuildContext context, WidgetRef ref) {
    DB().getHistoryItems(ref);
    final historyItems = ref.watch(historyItemProvider);
    return Scaffold(
      body:
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
                  final item =historyItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: item[6] == 'true' ? Colors.white : Colors.red,
                      ),
                      title: Row(
                        children: [
                          Column(
                            children: [
                              Text(item[0])
                            ],
                          ),
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
    );
  }
}
