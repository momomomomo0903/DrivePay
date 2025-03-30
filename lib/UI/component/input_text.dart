import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final String hintText;
  final double width;
  final TextEditingController controller;

  const InputText({
    super.key,
    required this.label,
    required this.hintText,
    required this.width,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 100,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF439A8C), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 40,
            color: Color(0xFF45C4B0),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Container(
            width: width,
            height: 40,
            alignment: Alignment.center,
            child: TextField(
              cursorColor: Color(0xFF45C4B0),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
