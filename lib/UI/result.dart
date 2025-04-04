// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int perPersonAmount;
  final int peopleCount;
  final double distance;

  const ResultPage({
    super.key,
    required this.perPersonAmount,
    required this.peopleCount,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    int totalAmount = perPersonAmount * peopleCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 350,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF4EC1B7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_car, color: Colors.white, size: 30),
                  const SizedBox(height: 10),
                  const Text(
                    'Drive Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '一人あたり',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    '¥$perPersonAmount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Text('距離　　　　${distance.toStringAsFixed(1)} Km', style: const TextStyle(fontSize: 16)),
            Text('一人　　　　${perPersonAmount}円 × ${peopleCount}人', style: const TextStyle(fontSize: 16)),
            Text('合計　　　　${totalAmount}円', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }}