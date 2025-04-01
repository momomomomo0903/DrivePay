import "package:drivepay/UI/component/input_conditions.dart";
import "package:drivepay/UI/component/input_text.dart";
import "package:drivepay/UI/result.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  // 経由地のコントローラーをリストで管理
  final List<TextEditingController> _viaControllers = [];

  @override
  void initState() {
    super.initState();
    // 初期状態で経由1だけ追加
    _viaControllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputText(
              label: '出発地',
              hintText: '駅、バス停、住所、施設',
              width: 320,
              controller: _fromController,
            ),
            const SizedBox(height: 16),

            // 複数の経由地を表示
            ..._viaControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputText(
                    label: '経由${index + 1}',
                    hintText: '駅、バス停、サービスエリア',
                    width: 320,
                    controller: controller,
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _viaControllers.add(TextEditingController());
                });
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFF45C4B0),
                size: 24,
              ),
              label: const Text(
                '経由地を追加',
                style: TextStyle(color: Color(0xFF45C4B0)),
              ),
            ),

            const SizedBox(height: 16),
            InputText(
              label: '到着地',
              hintText: '駅、バス停、住所、施設',
              width: 320,
              controller: _toController,
            ),
            const SizedBox(height: 16),
            InputText(
              label: '乗車人数',
              hintText: '',
              width: 50,
              controller: _numberController,
            ),
            const SizedBox(height: 20),
            InputConditions(),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF45C4B0),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: 最終的にこれらの値をResultPageに渡す
                  final from = _fromController.text;
                  final viaList = _viaControllers.map((c) => c.text).toList();
                  final to = _toController.text;

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResultPage()),
                  );
                },
                child: const Text('計算する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
