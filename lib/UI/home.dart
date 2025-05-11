// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import "package:drivepay/UI/component/input_conditions.dart";
import "package:drivepay/UI/component/input_text.dart";
import 'package:drivepay/UI/result.dart';
import 'package:drivepay/config/api_key.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/state/home_status.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivepay/services/group_service.dart';
import 'package:drivepay/UI/component/home/group_dropdown.dart';

final String apiKey = ApiKeys.api_key;
List<Map<String, dynamic>> _groups = [];
String? _selectedGroupId = null;

Future<Map<String, dynamic>> fetchData(
  String from,
  String to,
  String number,
  String? parking,
  String? highway,
  List<String> viaList,
) async {
  try {
    // 経由地をパイプ区切りで結合
    final String viaString = viaList.join('|');
    final String waypointsParam =
        viaString.isNotEmpty ? '&waypoints=$viaString' : '';

    final Uri uri = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json"
      "?origin=${Uri.encodeComponent(from)}"
      "&destination=${Uri.encodeComponent(to)}"
      "$waypointsParam"
      "&key=$apiKey",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // すべての legs の距離を合算
      double totalDistanceMeters = 0;
      for (var leg in data['routes'][0]['legs']) {
        totalDistanceMeters += leg['distance']['value'];
      }

      final distanceKm = totalDistanceMeters / 1000.0;

      final parkingFee = int.tryParse(parking ?? '') ?? 0;
      final highwayFee = int.tryParse(highway ?? '') ?? 0;
      // ガソリン代を別途計算するため、ここでは含めない
      final sumFare = parkingFee + highwayFee;
      final perPersonFee = sumFare / int.parse(number);

      debugPrint(
        "✅ 合計料金（円）: ${sumFare.toStringAsFixed(1)}\n"
        "一人当たりの料金: ${perPersonFee.toStringAsFixed(1)}\n"
        "距離（キロメートル）: ${distanceKm.toStringAsFixed(1)}",
      );
      return {
        'distance': distanceKm,
        'total': sumFare.toInt(),
        'perPerson': perPersonFee.toInt(),
        'people': int.parse(number),
      };
    } else {
      debugPrint("❌ エラー: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint('エラー: $e');
    rethrow;
  }

  throw Exception('データの取得に失敗しました');
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _highwayController = TextEditingController();
  final TextEditingController _rentalFeeController = TextEditingController();

  // 経由地のコントローラーをリストで管理
  final List<TextEditingController> _viaControllers = [];

  // レンタカー関連の状態管理
  bool _isRentalCar = false;
  bool _includeGasFee = false;  // ガソリン代を含めるかどうかのフラグ

  // エラーダイアログを表示する関数
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 現在地を取得する関数
  Future<void> getCurrentLocation() async {
    try {
      // 位置情報サービスが有効かチェック
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('位置情報サービスが無効になっています。\n設定から位置情報を有効にしてください。');
        return;
      }

      // 位置情報の権限をチェック
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('位置情報の利用が拒否されました。\n設定から位置情報の利用を許可してください。');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog('位置情報の利用が永久に拒否されています。\n設定アプリから位置情報の利用を許可してください。');
        return;
      }

      // 位置情報を取得
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // タイムアウトを10秒に設定
      );

      // 住所に変換
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey&language=ja',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          setState(() {
            _fromController.text = data['results'][0]['formatted_address'];
          });
        } else {
          _showErrorDialog('住所の取得に失敗しました。\nエラー: ${data['status']}');
        }
      } else {
        _showErrorDialog('住所の取得に失敗しました。\nステータスコード: ${response.statusCode}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        _showErrorDialog('位置情報の取得がタイムアウトしました。\nもう一度お試しください。');
      } else {
        _showErrorDialog('現在地の取得に失敗しました。\nエラー: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 初期状態で経由1だけ追加
    _viaControllers.add(TextEditingController());
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null && uid.isNotEmpty) {
      GroupService.fetchUserGroups(uid)
          .then((groups) {
            setState(() {
              _groups = groups;
            });
          })
          .catchError((error) {
            debugPrint('グループの取得に失敗しました: $error');
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(isLoginProvider);
    return Scaffold(
      backgroundColor: Color(0xFFF6FFFE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: getCurrentLocation,
                child: Row(
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
              ),
              const SizedBox(height: 2),
              InputText(
                label: '出発地',
                hintText: '駅、バス停、住所、施設',
                width: MediaQuery.of(context).size.width - 32,
                controller: _fromController,
              ),
              const SizedBox(height: 10),

              // 複数の経由地を表示
              ..._viaControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputText(
                            label: '経由${index + 1}',
                            hintText: '駅、サービスエリア',
                            width: MediaQuery.of(context).size.width - 32,
                            controller: controller,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color(0xFFdf5656),
                          ),
                          onPressed: () {
                            setState(() {
                              _viaControllers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              TextButton.icon(
                onPressed: () {
                  if (_viaControllers.length < 3) {
                    setState(() {
                      _viaControllers.add(TextEditingController());
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('経由地は最大3つまでです'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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

              const SizedBox(height: 10),
              InputText(
                label: '到着地',
                hintText: '駅、バス停、住所、施設',
                width: MediaQuery.of(context).size.width - 32,
                controller: _toController,
              ),
              const SizedBox(height: 16),
              // ラベル行
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text('乗車人数', style: TextStyle(fontSize: 16, color: Color(0xFF45C4B0))),
                  ),
                  SizedBox(width: 17),
                  SizedBox(
                    width: 150,
                    child: Text('グループを選択', style: TextStyle(fontSize: 16, color: Color(0xFF45C4B0))),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 入力行
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: InputText(
                      label: '乗車人数',
                      hintText: '',
                      width: 150,
                      controller: _numberController,
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 150,
                    child: GroupDropdown(
                      groups: _groups,
                      selectedGroupId: _selectedGroupId,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGroupId = newValue;
                          final selectedGroup = _groups.firstWhere(
                            (group) => group['groupId'] == newValue,
                            orElse: () => {},
                          );
                          if (selectedGroup.isNotEmpty && selectedGroup.length != null) {
                            _numberController.text = selectedGroup["members"].length.toString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // レンタカー選択
              Row(
                children: [
                  const Text('レンタカーですか？'),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isRentalCar,
                        onChanged: (bool? value) {
                          setState(() {
                            _isRentalCar = value ?? false;
                          });
                        },
                      ),
                      const Text('はい'),
                      Radio<bool>(
                        value: false,
                        groupValue: _isRentalCar,
                        onChanged: (bool? value) {
                          setState(() {
                            _isRentalCar = value ?? false;
                          });
                        },
                      ),
                      const Text('いいえ'),
                    ],
                  ),
                ],
              ),

              // レンタカーが選択された場合の追加フィールド
              if (_isRentalCar) ...[
                const SizedBox(height: 10),
                InputText(
                  label: '借料',
                  hintText: '円',
                  width: 150,
                  controller: _rentalFeeController,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _includeGasFee,
                      onChanged: (bool? value) {
                        setState(() {
                          _includeGasFee = value ?? false;
                        });
                      },
                    ),
                    const Text('ガソリン代を計算に含める'),
                  ],
                ),
              ],

              const SizedBox(height: 10),

              InputConditions(
                parkingController: _parkingController,
                highwayController: _highwayController,
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.only(left: 70.0, right: 70.0),
                    backgroundColor: Color(0xFF45C4B0),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // バリデーションチェック
                    String? errorMessage;

                    // 既存のバリデーション
                    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
                      errorMessage = '出発地と到着地を入力してください';
                    } else if (_numberController.text.isEmpty) {
                      errorMessage = '乗車人数を入力してください';

                      // 乗車人数の数値チェック
                    } else if (!RegExp(r'^\d+$').hasMatch(_numberController.text)) {
                      errorMessage = '乗車人数は数値で入力してください';
                    } else if (int.parse(_numberController.text) <= 0) {
                      errorMessage = '乗車人数は1人以上で入力してください';
                    } else if (_parkingController.text.isNotEmpty &&
                        !RegExp(r'^\d+$').hasMatch(_parkingController.text)) {
                      errorMessage = '駐車場代は数値で入力してください';
                    } else if (_highwayController.text.isNotEmpty &&
                        !RegExp(r'^\d+$').hasMatch(_highwayController.text)) {
                      errorMessage = '高速代は数値で入力してください';
                    }

                    // レンタカー関連のバリデーション
                    if (_isRentalCar) {
                      if (_rentalFeeController.text.isEmpty) {
                        errorMessage = 'レンタル代を入力してください';
                      } else if (!RegExp(r'^\d+$').hasMatch(_rentalFeeController.text)) {
                        errorMessage = 'レンタル代は数値で入力してください';
                      }
                    }

                    if (errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // バリデーション成功時の処理
                    final from = _fromController.text;
                    final viaList = _viaControllers.map((c) => c.text).toList();
                    final to = _toController.text;
                    final number = _numberController.text;
                    final parking = _parkingController.text;
                    final highway = _highwayController.text;
                    final rentalFee = _isRentalCar ? int.parse(_rentalFeeController.text) : 0;

                    final result = await fetchData(
                      from,
                      to,
                      number,
                      parking,
                      highway,
                      viaList,
                    );
                    // レンタカーとガソリン代の計算を追加
                    double totalCost = result['total'].toDouble();
                    // ガソリン代を計算（ユーザー設定の燃費を使用）
                    final userFuelEfficiency = double.parse(ref.read(fuelEfficiencyProvider));
                    final gasPricePerLiter = 170.0; // 1Lあたり170円
                    final gasFee = (result['distance'] / userFuelEfficiency) * gasPricePerLiter;
                    
                    if (_isRentalCar) {
                      totalCost += rentalFee;
                      if (_includeGasFee) {
                        totalCost += gasFee;
                      }
                    } else {
                      // 自家用車の場合は常にガソリン代を含める
                      totalCost += gasFee;
                    }

                    final perPersonCost = totalCost / int.parse(number);
                    
                    if (isLogin) {
                      ref.read(fromProvider.notifier).state = from;
                      ref.read(toProvider.notifier).state = to;
                      ref.read(groupIdProvider.notifier).state =
                          '1745671777187'; // rkt9tuba4develop@gmail.com内のグループIDを仮で利用
                    }
                    // 結果を表示するページに遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          perPersonAmount: perPersonCost.toInt(),
                          peopleCount: result['people'],
                          distance: result['distance'],
                          groupId: _selectedGroupId,
                        ),
                      ),
                    );
                  },
                  child: const Text('計算する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
