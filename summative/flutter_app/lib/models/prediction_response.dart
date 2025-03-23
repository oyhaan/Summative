// lib/models/prediction_response.dart
class PredictionResponse {
  final double predictedYield;
  final String unit;

  PredictionResponse({
    required this.predictedYield,
    required this.unit,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      predictedYield: (json['predicted_yield'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }
}