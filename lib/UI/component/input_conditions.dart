import 'package:flutter/material.dart';

class InputConditions extends StatelessWidget {
  final TextEditingController? parkingController;
  final TextEditingController? highwayController;

  const InputConditions({
    super.key,
    this.parkingController,
    this.highwayController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConditionRow('〇 駐車場代', parkingController),
                _buildConditionRow(
                  '〇 高速代',
                  highwayController,
                  showBottomBorder: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionRow(
    String label,
    TextEditingController? controller, {
    bool showBottomBorder = true,
  }) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 40,
          color: Color(0xFF45C4B0),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
        Flexible(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFF6FFFE),
              border: Border(
                left: BorderSide(color: Color(0xFF439A8C), width: 2),
                bottom: showBottomBorder
                    ? BorderSide(color: Color(0xFF439A8C), width: 2)
                    : BorderSide.none,
              ),
            ),
            child: TextField(
              controller: controller,
              cursorColor: Color(0xFF45C4B0),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '数値を入力',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 10, left: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
