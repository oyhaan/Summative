// lib/pages/result_page.dart
import 'package:flutter/material.dart';
import '../models/prediction_response.dart';

class ResultPage extends StatelessWidget {
  final PredictionResponse prediction;

  const ResultPage({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Result'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Water Quality Prediction',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Predicted Dissolved Oxygen: ${prediction.predictedDissolvedOxygen.toStringAsFixed(2)} mg/L',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        prediction.safetyMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: prediction.safetyMessage.contains('Warning')
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
