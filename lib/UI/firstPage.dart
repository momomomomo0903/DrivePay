// ignore_for_file: file_names
import "package:flutter/material.dart";
import 'package:drivepay/UI/fotter_menu.dart';

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.only(top: 50.0)),
          Text(
            "Drive Pay",
            style: TextStyle(fontFamily: 'Modak', fontSize: 30.0),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            child: const Text('はじめる'),
          ),
        ],
      ),
    );
  }
}
