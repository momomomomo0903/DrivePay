// ignore_for_file: unnecessary_brace_in_string_interps
import 'package:drivepay/UI/component/result/share_icon.dart';
import 'package:drivepay/UI/component/result/to_homepage_button.dart';
import 'package:drivepay/UI/component/result/defaulter_list.dart';
import 'package:drivepay/logic/firebase.dart';
import 'package:drivepay/services/group_service.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/state/home_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/fotter_menu.dart';

class ResultPage extends ConsumerStatefulWidget {
  final int perPersonAmount;
  final int peopleCount;
  final double distance;
  final String? groupId;
  final int? parkingFee; // 駐車場代（オプション）
  final int? highwayFee; // 高速代（オプション）
  final int? gasFee; // ガソリン代（オプション）
  final int? rentalFee; // レンタル代（オプション）

  const ResultPage({
    super.key,
    required this.perPersonAmount,
    required this.peopleCount,
    required this.distance,
    this.groupId,
    this.parkingFee,
    this.highwayFee,
    this.gasFee,
    this.rentalFee,
  });

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  List<String> _members = [];
  bool _hasAddedHistory = false;
  bool _showBreakdown = false; // 内訳表示フラグ

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.groupId == null) return;
    {
      GroupService.fetchGroupMembers(uid: uid, groupId: widget.groupId!).then((
        members,
      ) {
        setState(() {
          _members = members;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addDriveHistory();
    });
  }

  void _addDriveHistory() {
    if (_hasAddedHistory) return;

    final isLogin = ref.read(isLoginProvider);
    final from = ref.read(fromProvider);
    final to = ref.read(toProvider);

    if (isLogin) {
      DB().firstAddDriveHistory(
        ref,
        from,
        to,
        widget.distance,
        widget.perPersonAmount,
        widget.groupId ?? '',
      );
      _hasAddedHistory = true;
    }
  }

  // 内訳表示を切り替えるメソッド
  void _toggleBreakdown() {
    setState(() {
      _showBreakdown = !_showBreakdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    final from = ref.watch(fromProvider);
    final to = ref.watch(toProvider);
    final isLogin = ref.watch(isLoginProvider);

    int totalAmount = widget.perPersonAmount * widget.peopleCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF45C4B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
            );
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 120, bottom: 80),
                decoration: const BoxDecoration(color: Color(0xFF45C4B0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          '一人あたり',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '¥${widget.perPersonAmount}',
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
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
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
                          '距離　　　　${widget.distance.toStringAsFixed(1)} Km',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8F8F8F),
                          ),
                        ),
                      ),

                      // 内訳表示に項目があるかチェック
                      if ((widget.gasFee != null && widget.gasFee! > 0) ||
                          (widget.rentalFee != null && widget.rentalFee! > 0) ||
                          (widget.parkingFee != null &&
                              widget.parkingFee! > 0) ||
                          (widget.highwayFee != null && widget.highwayFee! > 0))
                        // 内訳を表示するボタン
                        ElevatedButton(
                          onPressed: _toggleBreakdown,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF45C4B0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            minimumSize: Size(300, 25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _showBreakdown ? '内訳を隠す' : '内訳を表示',
                                style: const TextStyle(
                                  color: Color(0xFF45C4B0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                _showBreakdown
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xFF45C4B0),
                              ),
                            ],
                          ),
                        ),

                      // 内訳表示（ボタンが押されたときのみ）
                      if (_showBreakdown) ...[
                        // ガソリン代の表示（値がある場合のみ）
                        if (widget.gasFee != null && widget.gasFee! > 0)
                          Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),

                            child: Text(
                              'ガソリン代　${widget.gasFee}円',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8F8F8F),
                              ),
                            ),
                          ),
                        // レンタル代の表示（値がある場合のみ）
                        if (widget.rentalFee != null && widget.rentalFee! > 0)
                          Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),

                            child: Text(
                              'レンタル代　${widget.rentalFee}円',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8F8F8F),
                              ),
                            ),
                          ),
                        // 駐車場代の表示（入力されている場合のみ）
                        if (widget.parkingFee != null && widget.parkingFee! > 0)
                          Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),

                            child: Text(
                              '駐車場代　　${widget.parkingFee}円',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8F8F8F),
                              ),
                            ),
                          ),
                        // 高速代の表示（入力されている場合のみ）
                        if (widget.highwayFee != null && widget.highwayFee! > 0)
                          Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),

                            child: Text(
                              '高速代　　　${widget.highwayFee}円',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8F8F8F),
                              ),
                            ),
                          ),
                      ],
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                          '一人　　　　${widget.perPersonAmount}円 × ${widget.peopleCount}人',
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
                          '合計　　　　${totalAmount}円',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8F8F8F),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),
                      DefaulterList(
                        maxCount: widget.peopleCount,
                        groupId: widget.groupId,
                      ),
                      const SizedBox(height: 35),

                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ToHomepageButton(),
                            ShareIconButton(
                              perPersonAmount: widget.perPersonAmount,
                            ),
                          ],
                        ),
                      ),
                    ],
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
