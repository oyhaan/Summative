// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/input_page.dart';

void main() {
  runApp(const CropYieldPredictorApp());
}

class CropYieldPredictorApp extends StatelessWidget {
  const CropYieldPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Yield Predictor',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: const InputPage(),
    );
  }
}