// ignore_for_file: file_names
import 'package:drivepay/logic/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoInputPage extends ConsumerStatefulWidget {
  final dynamic item;

  const MemoInputPage({super.key, required this.item});

  @override
  ConsumerState<MemoInputPage> createState() => _MemoInputPageState();
}

class _MemoInputPageState extends ConsumerState<MemoInputPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item[7]); // item[7]を初期値に
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveMemo() async {
    final newMemo = _controller.text;
    setState(() {
      widget.item[7] = newMemo;
      DB.writeMemo(ref, item: widget.item); // メモをFirebaseに書き込む
    });

    await DB().getHistoryItems(ref);
    Navigator.pop(context, newMemo); // 戻り値として渡すことも可能
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ編集'),
        backgroundColor: const Color(0xff45C4B0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('メモを入力してください', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'メモを入力',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMemo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff45C4B0),
                ),
                child: const Text('保存'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
