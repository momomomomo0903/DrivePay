import "package:drivepay/UI/component/input_conditions.dart";
import "package:drivepay/UI/component/input_text.dart";
import 'package:drivepay/UI/result.dart';
import 'package:drivepay/config/api_key.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

final String apiKey = ApiKeys.api_key;
void fetchData(
  String from,
  String to,
  String number,
  String? parking,
  String? highway,
) async {
  final response = await http.get(
    Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json?origin=$from&destination=$to&key=$apiKey",
    ),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final distancekiroMeters =
        data['routes'][0]['legs'][0]['distance']['value'] / 1000;

    //  Nullや空文字なら0にする
    final parkingFee = int.tryParse(parking ?? '') ?? 0;
    final highwayFee = int.tryParse(highway ?? '') ?? 0;

    final sumFare = distancekiroMeters * 15 + parkingFee + highwayFee;
    final perPersonFee = sumFare / int.parse(number);

    print(
      "✅ 合計料金（円）: $sumFare\n"
      "一人当たりの料金: $perPersonFee\n"
      "距離（キロメートル）: $distancekiroMeters",
    );
  } else {
    print("❌ エラー: ${response.statusCode}");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _highwayController = TextEditingController();

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
      backgroundColor: Color(0xFFF6FFFE),
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 30.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFdf5656),
                  size: 24,
                ),
                const Text(
                  '現在地から出発',
                  style: TextStyle(color: Color(0xFF45C4B0)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            InputText(
              label: '出発地',
              hintText: '駅、バス停、住所、施設',
              width: 251,
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
                    width: 251,
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
              width: 251,
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
            InputConditions(
              parkingController: _parkingController,
              highwayController: _highwayController,
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 70.0, right: 70.0),
                  backgroundColor: Color(0xFF45C4B0),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: 最終的にこれらの値をResultPageに渡す
                  final from = _fromController.text;
                  final viaList = _viaControllers.map((c) => c.text).toList();
                  final to = _toController.text;
                  final number = _numberController.text;
                  final parking = _parkingController.text;
                  final highway = _highwayController.text;
                  fetchData(from, to, number, parking, highway);
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
