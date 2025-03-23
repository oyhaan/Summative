// lib/models/prediction_response.dart
class PredictionResponse {
  final double predictedDissolvedOxygen;
  final String safetyMessage;

  PredictionResponse({
    required this.predictedDissolvedOxygen,
    required this.safetyMessage,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      predictedDissolvedOxygen:
          (json['predicted_dissolved_oxygen'] as num).toDouble(),
      safetyMessage: json['safety_message'] as String,
    );
  }
}
