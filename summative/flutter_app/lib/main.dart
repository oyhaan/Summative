// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/input_page.dart';

void main() {
  runApp(const WaterQualityPredictorApp());
}

class WaterQualityPredictorApp extends StatelessWidget {
  const WaterQualityPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Quality Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InputPage(),
    );
  }
}
