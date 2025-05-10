import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String hintText;
  final double width;
  final TextEditingController controller;
  final bool enabled;

  const InputText({
    super.key,
    this.label,
    this.icon,
    required this.hintText,
    required this.width,
    required this.controller,
    this.enabled = true,
  }) : assert(
         label != null || icon != null,
         'Either label or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF439A8C), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 47,
              color: Color(0xFF45C4B0),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Center(
                child:
                    icon != null
                        ? Icon(icon, color: Colors.white, size: 24)
                        : Text(
                          label!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                color: Color(0xFFF6FFFE),
                alignment: Alignment.center,
                child: TextField(
                  enabled: enabled,
                  cursorColor: Color(0xFF45C4B0),
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
