// ignore_for_file: unnecessary_brace_in_string_interps
import 'package:drivepay/UI/component/result/share_icon.dart';
import 'package:drivepay/UI/component/result/to_homepage_button.dart';
import 'package:drivepay/UI/component/result/defaulter_list.dart';
// import 'package:drivepay/UI/component/result/defaulter_list_group.dart';
import 'package:drivepay/UI/home.dart';
import 'package:drivepay/services/group_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResultPage extends ConsumerStatefulWidget {
  final int perPersonAmount;
  final int peopleCount;
  final double distance;
  final String? groupId;

  const ResultPage({
    super.key,
    required this.perPersonAmount,
    required this.peopleCount,
    required this.distance,
    this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(fromProvider);
    final to = ref.watch(toProvider);
    final groupId = ref.watch(groupIdProvider);
    final isLogin = ref.watch(isLoginProvider);

    int totalAmount = perPersonAmount * peopleCount;
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  List<String> _members = [];

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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(fromProvider);
    final to = ref.watch(toProvider);
    final groupId = ref.watch(groupIdProvider);
    final isLogin = ref.watch(isLoginProvider);

    int totalAmount = perPersonAmount * peopleCount;
    int totalAmount = widget.perPersonAmount * widget.peopleCount;

    if (isLogin) {
      DB().firstAddDriveHistory(ref, from, to, distance, perPersonAmount, groupId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                        padding: const EdgeInsets.only(left: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ToHomepageButton(),
                            ShareIconButton(perPersonAmount: widget.perPersonAmount),
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
