import 'package:flutter/material.dart';

class InputConditions extends StatelessWidget {
  const InputConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 334,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF439A8C), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            color: Color(0xFF45C4B0),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Text('条件', style: TextStyle(color: Colors.white)),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    color: Color(0xFF45C4B0),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text(
                      '〇 駐車場代',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF439A8C), width: 2),
                      ),
                    ),
                    child: const TextField(
                      cursorColor: Color(0xFF45C4B0),
                      decoration: InputDecoration(
                        hintText: '数値を入力',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    color: Color(0xFF45C4B0),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text(
                      '〇 高速代',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(),
                    child: const TextField(
                      cursorColor: Color(0xFF45C4B0),
                      decoration: InputDecoration(
                        hintText: '数値を入力',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
