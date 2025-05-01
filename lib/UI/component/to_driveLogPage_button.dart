import 'package:drivepay/UI/fotter_menu.dart';
import 'package:flutter/material.dart';

class ToDriveLogpageButton extends StatelessWidget {
  const ToDriveLogpageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.only(left: 40, right: 40),
        backgroundColor: const Color(0xFF45C4B0),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 1)),
          (route) => false,
        );
      },
      child: const Text('戻る'),
    );
  }
}